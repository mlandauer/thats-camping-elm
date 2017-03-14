var Elm = require('./elm/Server.elm');

var app = Elm.Server.worker();

app.ports.response.subscribe(respond);

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
  //console.log("sync active");
}).on('denied', function (err) {
  // a document failed to replicate (e.g. due to permissions)
  console.log("sync denied:", err);
}).on('complete', function (info) {
  // handle complete
  console.log("Finished synching campsite data...");
  // TODO: Start live sync
  console.log("Loading campsite data...");
  db.changes({include_docs: true}).on('change', function(change) {
    app.ports.changeSuccess.send(change);
  }).on('complete', function(info) {
    console.log("Finished loading campsite data");
    // TODO: Now start collecting live changes
    startServer();
  }).on('error', function (err) {
    console.log(err);
  });
}).on('error', function (err) {
  // handle error
  console.log("sync error:", err);
});

var connectionId = 0;
var responses = {};

function startServer() {
  var http = require('http');
  const PORT=8080;

  function handleRequest(request, response){
    // Super simple way to give each request/response a unique id
    // that can be used to route the response from elm to the
    // correct request from the web
    responses[connectionId] = response;
    // Now Send a request to elm (via ports)
    app.ports.request.send(connectionId);
    connectionId++;
  }

  var server = http.createServer(handleRequest);

  server.listen(PORT, function(){
    //Callback triggered when server is successfully listening. Hurray!
    console.log("Server listening on: http://localhost:%s", PORT);
});
}

function respond(response) {
  responses[response.id].end(response.html);
  delete responses[response.id];
}
