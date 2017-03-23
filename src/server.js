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
  var path = require('path');
  const PORT=8080;

  function handleRequest(request, response, next){
    var staticPath = "docs" + request.url;
    // TODO: I guess we don't want it serving up the server code
    // TODO: Do gzipping (or make webpack gzip thing)
    // TODO: Add support for ssl cert
    if (request.url != "/" && fs.existsSync(staticPath)) {
      var file = fs.readFileSync(staticPath);
      var extname = path.extname(staticPath);
      var contentType = 'text/html';
      switch (extname) {
          case '.html':
              contentType = 'text/html';
              break;
          case '.js':
              contentType = 'text/javascript';
              break;
          case '.css':
              contentType = 'text/css';
              break;
          case '.json':
              contentType = 'application/json';
              break;
          case '.png':
              contentType = 'image/png';
              break;
          case '.jpg':
              contentType = 'image/jpg';
              break;
          case '.appcache':
              contentType = 'text/cache-manifest';
              break;
          case '.map':
              // See http://stackoverflow.com/questions/19911929/what-mime-type-should-i-use-for-javascript-source-map-files
              contentType = 'application/json';
              break;
          case '.woff':
              contentType = 'application/font-woff';
              break;
          case '.ttf':
              contentType = 'application/octet-stream';
              break;
          case '.svg':
              contentType = 'image/svg+xml';
              break;
          case '.woff2':
              contentType = 'font/woff2';
              break;
          case '.eot':
              contentType = 'application/vnd.ms-fontobject';
              break;
      }

      response.writeHead(200, { 'Content-Type': contentType });
      response.end(file);
    } else {
      // Super simple way to give each request/response a unique id
      // that can be used to route the response from elm to the
      // correct request from the web
      responses[connectionId] = response;
      // Now Send a request to elm (via ports)
      app.ports.request.send({id: connectionId, url: request.url});
      connectionId++;
    }
  }

  var server = express();

  server.get('*', handleRequest);

  server.listen(PORT, function () {
    console.log("Server listening on: http://localhost:%s", PORT);
  });
}

function respond(response) {
  var template = fs.readFileSync("src/index_server_side.html", {encoding: 'utf8'});
  var template = template.replace("{{app}}", response.html);
  responses[response.id].writeHead(200, { 'Content-Type': 'text/html' });
  responses[response.id].end(template);
  delete responses[response.id];
}
