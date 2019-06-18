const { storeCardActivation, blockCard } = require('../data/cardRepository');

exports.activateCard = card => storeCardActivation(card);
exports.blockCard = id => blockCard(id);
