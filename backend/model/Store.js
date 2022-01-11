const mongoose = require('mongoose');

const accountSchema = new mongoose.Schema({
    lat: Number,
    long: Number,
    name: String,
    intro: String,
    address: String
});

module.exports = mongoose.model('stores', accountSchema);
