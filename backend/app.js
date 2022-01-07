var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
const mongoose = require('mongoose');
mongoose.connect('mongodb://localhost:27017/dim_sum_app_db').then(console.log("db ok")).catch(err => console.log(err));

var authRouter = require('./routes/auth');
var dimSumRouter = require('./routes/dimsum');
var accountRouter = require('./routes/account');

var app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/api/auth', authRouter);
app.use('/api/dimsum', dimSumRouter);
app.use('/api/account', accountRouter);

module.exports = app;
