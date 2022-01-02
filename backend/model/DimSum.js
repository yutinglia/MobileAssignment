const mongoose = require('mongoose');

const dimSumSchema = new mongoose.Schema({
    name: String
});

module.exports = mongoose.model('dim_sums', dimSumSchema);
