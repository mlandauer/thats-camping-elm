'use strict';

require('./style.css');
// require('font-awesome/css/font-awesome.css');

// Require index.html so it gets copied to dist
require('./index.html');

require('./apple-touch-icon.png');

var PouchDB = require('pouchdb');

var Elm = require('./App.elm');


var node = document.getElementById('root');
var app = Elm.App.embed(node);

app.ports.put.subscribe(function(data) {
  console.log("Just received:", data);
  var db = new PouchDB('thats-camping');
  db.put(data).catch(function (err) {
    app.ports.putError.send(err);
    console.log(err);
  });
});
