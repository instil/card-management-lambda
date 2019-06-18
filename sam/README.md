# Card Management Lambda - SAM

This will create a cloud formation stack with:

- API Gateway with 2 POST Endpoints
- Activate Card function
- Block Card function
- DynamoDB table named "cards-sam"

## Setup

1. Ensure you have node.js and NPM installed
2. Ensure you have AWS CLI installed and authenticated
3. Install the SAM CLI: - https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install-mac.html
4. Uninstall the Serverless Framework or Terraform version from your AWS account if needed

## Deployment
    npm install

    cd sam

    aws s3 mb s3://card-management-sam

    sam package --template-file template.yaml --s3-bucket card-management-sam --output-template-file packaged.yaml --debug

    aws cloudformation deploy --template-file packaged.yaml --stack-name card-management-sam --capabilities CAPABILITY_IAM


---------------

## Endpoints

### Activate Card Endpoint

POST:

    {
    	"pan:": "1234123412341234",
    	"expiryDate": "12/20"
    }

RESPONSE:

    {
      "id": "08996440-8d19-11e9-b5fc-070c28af1f8c",
      "pan:": "1234",
      "expiryDate": "12/20"
    }

### Block Card Endpoint

POST:

    {
    	"id:": "08996440-8d19-11e9-b5fc-070c28af1f8c"
    }

RESPONSE:

    {} //200 ok
