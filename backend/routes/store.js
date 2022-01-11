var express = require('express');
var router = express.Router();
const Store = require('../model/Store')

router.get('/', async function (req, res, next) {
    try {
        const stores = await Store.find();
        res.json(stores);
    } catch (err) {
        console.log(err);
        res.status(500).send("oof");
    }
});

module.exports = router;

