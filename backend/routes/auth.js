var express = require('express');
var router = express.Router();
const Account = require('../model/Account');
var jwt = require('jsonwebtoken');
var { v4: uuidv4 } = require('uuid');
var config = require("../config");
var crypto = require('crypto');

// refresh token
router.get('/', async function (req, res, next) {
  try {
    let token = req.headers.authorization;
    if (!token) {
      res.status(500).send("oof");
      return;
    }
    jwt.verify(token, config.JWT_SECRET_KEY, function (err, decoded) {
      if (err) {
        res.json({
          account: "0",
          token: "0"
        });
      } else {
        const uuid = uuidv4();
        const { ac } = decoded;
        const token = jwt.sign({ ac, uuid }, config.JWT_SECRET_KEY, { expiresIn: config.JWT_EXPIRES_TIME });
        res.json({
          account: ac,
          token: token
        });
      }
    })
  } catch (err) {
    console.log(err);
    res.status(500).send("oof");
  }
});

// get access token
router.post('/', async function (req, res, next) {
  try {
    const { ac, pwd } = req.body;
    const hash = crypto.createHash('sha256').update("HAHA" + pwd + "LOL" + ac).digest('hex');
    const account = await Account.findOne({ account: ac, password: hash });
    if (!account) {
      // login fail
      res.json({ account: "0", token: "0" });
    } else {
      const uuid = uuidv4();
      const token = jwt.sign({ ac, uuid }, config.JWT_SECRET_KEY, { expiresIn: config.JWT_EXPIRES_TIME });
      res.json({
        account: ac,
        token: token
      });
    }
  } catch (err) {
    console.log(err);
    res.status(500).send("oof");
  }
});

module.exports = router;
