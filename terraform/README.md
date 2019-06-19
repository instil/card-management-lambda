# Card Management Lambda - Terraform

This will create the following resources:

- API Gateway with 2 POST Endpoints
- Activate Card function
- Block Card function
- DynamoDB table named "cards"

## Setup

1. Ensure you have node.js and NPM installed
2. Ensure you have AWS CLI installed and authenticated
3. Install terraform: - `brew install terraform`
4. Init terraform: - `terraform init`

## Deployment
    `npm install`
    `cd src`
    `zip -r ../terraform/cardManagement_lambda.zip .`
    `terraform plan`
    `terraform apply`


## Tear Down
    `terraform destroy`

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
