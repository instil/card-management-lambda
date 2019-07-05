# Card Management Lambda - CDK

This will create a cloud formation stack with:

- API Gateway with 2 POST Endpoints
- Activate Card function
- Block Card function
- DynamoDB table named "cards-cdk"

## Setup

    TODO

## Deployment
    TODO


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
