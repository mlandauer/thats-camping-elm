var Elm = require('./elm/Server.elm');

var app = Elm.Server.worker({version: VERSION});

app.ports.response.subscribe(respond);

var PouchDB = require('pouchdb');
var fs = require('fs');

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
db.sync(remoteDb, {}).on('denied', function (err) {
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
  var express = require('express');
  var compression = require('compression');
  var port = process.env.PORT || 8080;

  function handleRequest(request, response, next){
    // Super simple way to give each request/response a unique id
    // that can be used to route the response from elm to the
    // correct request from the web
    responses[connectionId] = response;
    // Now Send a request to elm (via ports)
    app.ports.request.send({id: connectionId, url: request.url});
    connectionId++;
  }

  var server = express();

  if (process.env.NODE_ENV === 'production') {
    server.use(function(req, res, next) {
      // TODO We should also be able to use req.protocol.
      // See http://expressjs.com/en/4x/api.html
      if (req.headers['x-forwarded-proto'] !== 'https')
      // TODO: Figure out root domain from request rather than hardcoding it here
        res.redirect("https://thatscamping.org" + req.url);
      else
        next();
    });
  }
  server.use(function(req, res, next){
    if (req.subdomains.length == 1 && req.subdomains[0] === "www") {
      // TODO: Figure out root domain from request rather than hardcoding it here
      res.redirect("https://thatscamping.org" + req.url);
    } else {
      next();
    }
  });
  server.use(compression());
  server.use(express.static('docs'));

  server.get('*', handleRequest);

  server.listen(port, function () {
    console.log("Server listening on: http://localhost:%s", port);
  });
}

function respond(response) {
  var template = fs.readFileSync("src/index_server_side.html", {encoding: 'utf8'});
  var template = template.replace("{{app}}", response.html);
  responses[response.id].writeHead(200, { 'Content-Type': 'text/html' });
  responses[response.id].end(template);
  delete responses[response.id];
}
