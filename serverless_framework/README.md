# Card Management Lambda - Serverless Framework

This will create a cloud formation stack with:

- API Gateway with 2 POST Endpoints
- Activate Card function
- Block Card function
- DynamoDB table named "cards"

## Setup

1. Ensure you have node.js and NPM installed
2. Ensure you have AWS CLI installed and authenticated
3. Install the serverless framework: - `npm install -g serverless`
4. Uninstall the SAM or Terraform version from your AWS account if needed

## Deployment
    npm install
    cd serverless_framework
    serverless deploy -v


## Tear Down
    serverless remove

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
