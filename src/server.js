var Elm = require('./elm/Server.elm');

var app = Elm.Server.worker();


app.ports.response.subscribe(function(response) {
  console.log("response:", response);
});

var PouchDB = require('pouchdb');

var db = new PouchDB('thats-camping.db');

var remoteDb = new PouchDB('https://mlandauer.cloudant.com/thats-camping', {
  auth: {
    // We're just using these tokens to get access to the remote database
    // temporarily.
    // TODO: Generate new tokens and remove from source code
    username: 'cirtionewessinstroonheen',
    password: '5e5308b9016a700156164970fbb346f9ede08e8e'
  }
});

console.log("Synching campsite data...");
db.sync(remoteDb, {}).on('change', function (info) {
  console.log("sync change:", info);
}).on('paused', function (err) {
  // replication paused (e.g. replication up to date, user went offline)
  //console.log("sync paused:", err);
}).on('active', function () {
  // replicate resumed (e.g. new changes replicating, user went back online)
  console.log("sync active");
}).on('denied', function (err) {
  // a document failed to replicate (e.g. due to permissions)
  console.log("sync denied:", err);
}).on('complete', function (info) {
  // handle complete
  console.log("Finished synching campsite data...");
  console.log("Loading campsite data...");
  db.changes({include_docs: true}).on('change', function(change) {
    app.ports.changeSuccess.send(change);
  }).on('complete', function(info) {
    console.log("Finished loading campsite data");
    // Now Send a request to elm (via ports)
    app.ports.request.send(null);
  }).on('error', function (err) {
    console.log(err);
  });
}).on('error', function (err) {
  // handle error
  console.log("sync error:", err);
});
