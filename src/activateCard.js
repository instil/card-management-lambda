const { activateCard } = require('./service/cardService');

const buildResponse = (statusCode, activatedCard) => {
  const body = JSON.stringify(activatedCard);
  return {
    statusCode,
    body
  };
};

exports.handler = async (event) => {
  console.log(`Received event ${JSON.stringify(event)}`);

  const card = JSON.parse(event.body);

  try {
    const activatedCard = await activateCard(card);
    return buildResponse(200, activatedCard);
  } catch (error) {
    console.error(JSON.stringify(error));
    return buildResponse(500);
  }
};
