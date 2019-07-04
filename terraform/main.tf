provider "aws" {
    region = "eu-west-1"
}

data "aws_caller_identity" "current" { }

##################
# IAM
##################

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "dynamodb-lambda-policy"{
  name = "dynamodb_lambda_policy"
  role = "${aws_iam_role.lambda_exec_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:*"
      ],
      "Resource": "${aws_dynamodb_table.cards.arn}"
    }
  ]
}
EOF
}

##################
# Lambdas
##################
resource "aws_lambda_function" "activateCard_lambda" {
    function_name = "activateCard_lambda"
    handler = "activateCard.handler"
    runtime = "nodejs8.10"
    filename = "cardManagement_lambda.zip"
    source_code_hash = filebase64sha256("cardManagement_lambda.zip")
    role = "${aws_iam_role.lambda_exec_role.arn}"
}

resource "aws_lambda_permission" "api-gateway-invoke-activateCard-lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.activateCard_lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the specified API Gateway.
  source_arn = "arn:aws:execute-api:eu-west-1:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.cardMgmtApi.id}/*/*"
  depends_on = ["aws_api_gateway_rest_api.cardMgmtApi", "aws_api_gateway_resource.card", "aws_api_gateway_resource.activate"]
}

resource "aws_lambda_function" "blockCard_lambda" {
    function_name = "blockCard_lambda"
    handler = "blockCard.handler"
    runtime = "nodejs8.10"
    filename = "cardManagement_lambda.zip"
    source_code_hash = filebase64sha256("cardManagement_lambda.zip")
    role = "${aws_iam_role.lambda_exec_role.arn}"
}

resource "aws_lambda_permission" "api-gateway-invoke-blockCard-lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.blockCard_lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the specified API Gateway.
  source_arn = "arn:aws:execute-api:eu-west-1:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.cardMgmtApi.id}/*/*"
}

##################
# API Gateway
##################
resource "aws_api_gateway_rest_api" "cardMgmtApi" {
  name        = "CardManagement"
  description = "Card Management API Gateway"
}

resource "aws_api_gateway_resource" "card" {
  rest_api_id = "${aws_api_gateway_rest_api.cardMgmtApi.id}"
  parent_id   = "${aws_api_gateway_rest_api.cardMgmtApi.root_resource_id}"
  path_part   = "card"
}

##################
# API Gateway - Activate
##################
resource "aws_api_gateway_resource" "activate" {
  rest_api_id = "${aws_api_gateway_rest_api.cardMgmtApi.id}"
  parent_id   = "${aws_api_gateway_resource.card.id}"
  path_part   = "activate"
}

resource "aws_api_gateway_method" "activate" {
  rest_api_id   = "${aws_api_gateway_rest_api.cardMgmtApi.id}"
  resource_id   = "${aws_api_gateway_resource.activate.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "activateLambda" {
  rest_api_id = "${aws_api_gateway_rest_api.cardMgmtApi.id}"
  resource_id = "${aws_api_gateway_method.activate.resource_id}"
  http_method = "${aws_api_gateway_method.activate.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.activateCard_lambda.invoke_arn}"
}

##################
# API Gateway - Block
##################
resource "aws_api_gateway_resource" "block" {
  rest_api_id = "${aws_api_gateway_rest_api.cardMgmtApi.id}"
  parent_id   = "${aws_api_gateway_resource.card.id}"
  path_part   = "block"
}

resource "aws_api_gateway_method" "block" {
  rest_api_id   = "${aws_api_gateway_rest_api.cardMgmtApi.id}"
  resource_id   = "${aws_api_gateway_resource.block.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "blockLambda" {
  rest_api_id = "${aws_api_gateway_rest_api.cardMgmtApi.id}"
  resource_id = "${aws_api_gateway_method.block.resource_id}"
  http_method = "${aws_api_gateway_method.block.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.blockCard_lambda.invoke_arn}"
}

resource "aws_api_gateway_deployment" "cardMgmtApiDeployment" {
  depends_on = [
    "aws_api_gateway_integration.activateLambda",
    "aws_api_gateway_integration.blockLambda",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.cardMgmtApi.id}"
  stage_name  = "test"
}
