var express = require('express');
var router = express.Router();
const DimSum = require('../model/DimSum')

router.post('/', async function (req, res, next) {
  try {
    const { name, imgURL, history, ingredients } = req.body;
    const siuMai = new DimSum({ name, imgURL, history, ingredients });
    const dimSum = await siuMai.save();
    res.json(dimSum);
  } catch (err) {
    console.log(err);
    res.status(500).send("oof");
  }
});

router.get('/', async function (req, res, next) {
  try {
    const dimSums = await DimSum.find();
    res.json(dimSums);
  } catch (err) {
    console.log(err);
    res.status(500).send("oof");
  }
});

module.exports = router;
