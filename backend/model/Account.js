const mongoose = require('mongoose');

const accountSchema = new mongoose.Schema({
    account: String,
    password: String,
    email: String,
    phone: String
});

module.exports = mongoose.model('accounts', accountSchema);
