var express = require('express');
var router = express.Router();
const DimSum = require('../model/DimSum')

router.get('/', async function (req, res, next) {
  try {
    const siuMai = new DimSum({ name: "Siu Mai" });
    const dimSum = await siuMai.save();
    res.json(dimSum);
  } catch (err) {
    console.log(err);
    res.status(500).send("oof");
  }
});

router.get('/list', async function (req, res, next) {
  try {
    const dimSums = await DimSum.find();
    res.json(dimSums);
  } catch (err) {
    console.log(err);
    res.status(500).send("oof");
  }
});

module.exports = router;
