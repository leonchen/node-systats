var express = require('express');
var app = express();

var Client = new require("../lib").Client;

var options = {};
var c = new Client(options);

app.listen(3030);
