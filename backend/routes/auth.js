var express = require('express');
var router = express.Router();
const Account = require('../model/Account')

// get access token
router.post('/', async function (req, res, next) {
  try {
    const { ac, pwd } = req.body;
    const account = await Account.findOne({ account: ac, password: pwd });
    if (!account) {
      // login fail
      res.json({ account: "0", email: "0", phone: "0", token: "0" });
    } else {
      res.json({
        account: ac,
        email: account.email,
        phone: account.phone,
        token: "i am token"
      });
    }
  } catch (err) {
    console.log(err);
    res.status(500).send("oof");
  }
});

module.exports = router;
