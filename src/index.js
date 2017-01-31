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

var db = new PouchDB('thats-camping');

db.changes({
  live: true,
  include_docs: true
}).on('change', function(change) {
  app.ports.change.send(change);
}).on('complete', function(info) {
  // TODO: Send this to a port
  console.log("complete", info);
}).on('error', function (err) {
  // TODO: Send this to a port
  console.log("error", err);
});

app.ports.put.subscribe(function(data) {
  // Using post at the moment so we don't have to deal with creating id's
  db.post(data)
    .then(function(response) {
      app.ports.putSuccess.send(response);
    })
    .catch(function (err) {
      if (err instanceof Error) {
        app.ports.putError.send({status: null, name: null, message: err.message, error: true});
      } else {
        app.ports.putError.send(err.message);
      }
    });
});

app.ports.destroy.subscribe(function(_) {
  db.destroy().then(function (response) {
    app.ports.destroySuccess.send(response);
  }).catch(function (err) {
    app.ports.destroyError.send(err);
  });
});

app.ports.bulkDocs.subscribe(function(data) {
  db.bulkDocs(data)
    .then(function(response) {
      console.log(response);
    }).catch(function(err) {
      console.log(err);
    });
});
