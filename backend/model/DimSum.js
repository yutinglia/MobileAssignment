const mongoose = require('mongoose');

const dimSumSchema = new mongoose.Schema({
    name: String,
    imgURL: String,
    history: String,
    ingredients: String,
    tutorial: [String]
});

module.exports = mongoose.model('dim_sums', dimSumSchema);
