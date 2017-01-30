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
  var db = new PouchDB('thats-camping');
  // Using post at the moment so we don't have to deal with creating id's
  db.post(data)
    .then(function(response) {
      app.ports.putSuccess.send(response);
    })
    .catch(function (err) {
      app.ports.putError.send(err);
    });
});
