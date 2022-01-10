var express = require('express');
const Account = require('../model/Account');
var router = express.Router();

router.get('/', async function (req, res, next) {
    try {
        const account = await Account.findOne({ account: req.auth.decoded.ac });
        res.json(account);
    } catch (err) {
        console.log(err);
        res.json({ status: 1 });
    }
});

router.put('/', async function (req, res, next) {
    try {
        const account = await Account.findOne({ account: req.auth.decoded.ac });
        res.json(account);
    } catch (err) {
        console.log(err);
        res.json({ status: 1 });
    }
});

module.exports = router;
