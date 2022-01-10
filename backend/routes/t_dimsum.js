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
            res.json({ status: 1 });
            return;
        }
        const arr = [];
        const siuMai = new DimSum({ name, info, history, ingredients, arr });
        await siuMai.save();
        res.json({ status: 0 });
    } catch (err) {
        console.log(err);
        res.json({ status: 1 });
    }
});

module.exports = router;
