var express = require('express');
var router = express.Router();
var crypto = require('crypto');
const Store = require('../model/Store');

// add store
router.post('/', async function (req, res, next) {
    try {
        const { lat, long, name, intro, address } = req.body;
        if (!lat || !long || !name || !intro || !address) {
            res.json({ status: 1, msg: "Information is not complete" });
            return;
        }
        const store = new Store({ lat, long, name, intro, address });
        const newStore = await store.save();
        console.log(newStore + " added");
        res.json({ status: 0, msg: "Store added" });
    } catch (err) {
        console.log(err);
        res.json({ status: 1, msg: "Unknow Error" });
    }
});

module.exports = router;
