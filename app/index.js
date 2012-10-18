// Generated by CoffeeScript 1.3.3
var app, assets, express, jsPathify, port, stylus;

express = require('express');

stylus = require('stylus');

assets = require('connect-assets');

jsPathify = require('connect-assets-jspaths');

app = express();

app.use(assets());

app.use(express["static"](process.cwd() + "/public"));

app.set('view engine', 'jade');

jsPathify(assets, console.log);

app.get(['/', '/about'], function(req, resp) {
  return resp.render('index');
});

port = process.env.PORT || process.env.VMC_APP_PORT || 3000;

app.listen(port, function() {
  return console.log("Listening on " + port + "\nPress CTRL-C to stop server.");
});
