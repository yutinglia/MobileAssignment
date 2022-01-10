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
            var name = `${req.body.name}_${req.auth.decoded.ac}.jpg`;
            cb(null, name);
        }
    })
})

router.post('/', upload.single('img'), async function (req, res, next) {
    try {
        const { ac: uploader } = req.auth.decoded;
        const { name, info, history, ingredients, tutorial } = req.body;
        const cDimSum = await DimSum.findOne({ name: name, uploader: uploader });
        if (cDimSum) {
            res.json({ status: 1, msg: "Dim Sum exist" });
            return;
        }
        if (!req.file || !name || !info || !history || !ingredients || !tutorial) {
            res.json({ status: 1, msg: "Information is not complete" });
            return;
        }
        const siuMai = new DimSum({ name, info, history, ingredients, uploader, tutorial });
        const d = await siuMai.save();
        console.log(d);
        res.json({ status: 0, msg: "Dim Sum Added" });
    } catch (err) {
        console.log(err);
        res.json({ status: 1, msg: "Unknow Error" });
    }
});

module.exports = router;
