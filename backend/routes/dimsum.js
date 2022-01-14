var express = require('express');
var router = express.Router();
const DimSum = require('../model/DimSum')

// get all dim sum
router.get('/', async function (req, res, next) {
  try {
    const dimSums = await DimSum.find();
    res.json(dimSums);
  } catch (err) {
    console.log(err);
    res.status(500).send("oof");
  }
});

// get dim sum image
router.get('/:name/img', async function (req, res, next) {
  try {
    res.download(`${__dirname}/../public/dimSumImg/${req.params.name}.jpg`);
  } catch (err) {
    console.log(err);
    res.status(500).send("oof");
  }
});

module.exports = router;
