var express = require('express');
var router = express.Router();
const Account = require('../model/Account');
var jwt = require('jsonwebtoken');
var { v4: uuidv4 } = require('uuid');
var config = require("../config");

// get access token
router.post('/', async function (req, res, next) {
  try {
    const { ac, pwd } = req.body;
    const account = await Account.findOne({ account: ac, password: pwd });
    if (!account) {
      // login fail
      res.json({ account: "0", email: "0", phone: "0", token: "0" });
    } else {
      const uuid = uuidv4();
      const token = jwt.sign({ ac, uuid }, config.JWT_SECRET_KEY, { expiresIn: config.JWT_EXPIRES_TIME });
      res.json({
        account: ac,
        email: account.email,
        phone: account.phone,
        token: token
      });
    }
  } catch (err) {
    console.log(err);
    res.status(500).send("oof");
  }
});

module.exports = router;
