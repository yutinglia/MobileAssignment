var express = require('express');
var router = express.Router();
const Account = require('../model/Account')

// create account
router.post('/', async function (req, res, next) {
    try {
        const { ac, pwd, email, phone } = req.body;
        const account = new Account({ account: ac, password: pwd, email, phone });
        const newAccount = await account.save();
        res.json(newAccount);
    } catch (err) {
        console.log(err);
        res.status(500).send("oof");
    }
});

module.exports = router;