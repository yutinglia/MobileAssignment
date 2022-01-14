var express = require('express');
const Account = require('../model/Account');
var router = express.Router();
var crypto = require('crypto');

// get account info
router.get('/', async function (req, res, next) {
    try {
        const account = await Account.findOne({ account: req.auth.decoded.ac });
        res.json(account);
    } catch (err) {
        console.log(err);
        res.json({ status: 1 });
    }
});

// edit account info
router.put('/info', async function (req, res, next) {
    try {
        const { email, phone } = req.body;
        if (!email || !phone) {
            res.json({ status: 1, msg: "Information is not complete" });
            return;
        }
        const account = await Account.findOneAndUpdate({ account: req.auth.decoded.ac }, { email, phone });
        res.json({ status: 0, msg: "Account Updated" });
    } catch (err) {
        console.log(err);
        res.json({ status: 1, msg: "Unknow Error" });
    }
});

// reset password
router.put('/pwd', async function (req, res, next) {
    try {
        const { pwd, opwd } = req.body;
        const { ac } = req.auth.decoded;
        if (!pwd || !opwd) {
            res.json({ status: 1, msg: "Password invaild" });
            return;
        }
        const hash = crypto.createHash('sha256').update("HAHA" + pwd + "LOL" + ac).digest('hex');
        const ohash = crypto.createHash('sha256').update("HAHA" + opwd + "LOL" + ac).digest('hex');
        console.log(ac, ohash);
        const na = await Account.findOneAndUpdate({ account: ac, password: ohash }, { password: hash });
        if (na) {
            res.json({ status: 0, msg: "Password reseted" });
        } else {
            res.json({ status: 1, msg: "Old Password Incorrent" });
        }
    } catch (err) {
        console.log(err);
        res.json({ status: 1, msg: "Unknow Error" });
    }
});

module.exports = router;
