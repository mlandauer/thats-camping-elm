var Elm = require('./elm/Server.elm');

var app = Elm.Server.worker();

// Send a request to elm (via ports)
app.ports.request.send(null);

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

db.changes({live: true}).on('change', function(change) {
  console.log("change:", change);
}).on('complete', function(info) {
  console.log("complete:", info);
}).on('error', function (err) {
  console.log(err);
});
