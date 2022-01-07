var express = require('express');
var router = express.Router();
const Account = require('../model/Account')
var crypto = require('crypto');

// create account
router.post('/', async function (req, res, next) {
    try {
        const { ac, pwd, email, phone } = req.body;
        if (!ac && !pwd && !email && !phone) {
            res.json({ status: 1, msg: "Information is not complete" });
            return;
        }
        // check account 
        const cAccount = await Account.findOne({ account: ac });
        if (cAccount) {
            res.json({ status: 1, msg: "Account exist" });
            return;
        }
        const pwdHash = crypto.createHash('sha256').update(pwd).digest('hex');
        const account = new Account({ account: ac, password: pwdHash, email, phone });
        const newAccount = await account.save();
        console.log(newAccount + " registered")
        res.json({ status: 0, msg: "Account register success" });
    } catch (err) {
        console.log(err);
        res.status(500).send("oof");
    }
});

module.exports = router;
