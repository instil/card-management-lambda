const { blockCard } = require('./service/cardService');

const buildResponse = statusCode => ({
  statusCode
});

exports.handler = async (event) => {
  console.log(`Received event ${JSON.stringify(event)}`);

  const { id } = JSON.parse(event.body);

  try {
    await blockCard(id);
    return buildResponse(200);
  } catch (error) {
    return buildResponse(500);
  }
};
