const AWS = require('aws-sdk');

AWS.config.update({ region: 'eu-west-1' });

exports.documentClient = new AWS.DynamoDB.DocumentClient({
  apiVersion: '2012-08-10'
});
