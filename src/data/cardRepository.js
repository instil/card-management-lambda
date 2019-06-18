const uuid = require('uuid/v1');
const { documentClient } = require('./dynamoDbClient');

const TABLE_NAME = 'cards';

exports.storeCardActivation = async (card) => {
  const activatedCard = {
    id: uuid(),
    ...card
  };

  const params = {
    TableName: TABLE_NAME,
    Item: activatedCard
  };

  console.log(`Storing card activation in DynamoDB: ${JSON.stringify(card)}`);

  await documentClient.put(params).promise();

  return activatedCard;
};

exports.blockCard = async (id) => {
  const params = {
    TableName: TABLE_NAME,
    Key: { id },
    UpdateExpression: 'set blocked = :blocked',
    ExpressionAttributeValues: {
      ':blocked': true
    }
  };

  console.log(`Blocking card in DynamoDB: ${id}`);

  await documentClient.update(params).promise();
};
