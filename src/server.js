var Elm = require('./elm/Server.elm');

var app = Elm.Server.worker();


app.ports.response.subscribe(function(response) {
  console.log("response:", response);
});

var PouchDB = require('pouchdb');

// Deal directly with the remote database since we don't need to support
// ofline behaviour here
var db = new PouchDB('https://mlandauer.cloudant.com/thats-camping', {
  auth: {
    // We're just using these tokens to get access to the remote database
    // temporarily.
    // TODO: Generate new tokens and remove from source code
    username: 'cirtionewessinstroonheen',
    password: '5e5308b9016a700156164970fbb346f9ede08e8e'
  }
});

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
