var express = require('express');
var router = express.Router();
const DimSum = require('../model/DimSum')
const multer = require('multer')

var upload = multer({
  storage: multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, `${__dirname}/../public/dimSumImg/`);
    },
    filename: function (req, file, cb) {
      var name = `${req.body.name}.jpg`;
      cb(null, name);
    }
  })
})

router.post('/', upload.single('img'), async function (req, res, next) {
  try {
    const { name, info, history, ingredients } = req.body;
    if (!req.file || !name || !info || !history || !ingredients) {
      res.status(500).send("oof");
      return;
    }
    const arr = [];
    const siuMai = new DimSum({ name, info, history, ingredients, arr });
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
