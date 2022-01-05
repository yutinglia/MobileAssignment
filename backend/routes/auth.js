var express = require('express');
var router = express.Router();
const Account = require('../model/Account')

// get access token
router.post('/', async function (req, res, next) {
  try {
    const { ac, pwd } = req.body;
    const accounts = await Account.find({ account: ac, password: pwd });
    if (accounts.length === 0) {
      res.json({ status: 1, err: "Account not found!" });
    } else {
      res.json({ status: 1, token: "i am token" });
    }
  } catch (err) {
    console.log(err);
    res.status(500).send("oof");
  }
});

module.exports = router;
