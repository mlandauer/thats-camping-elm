var Elm = require('./elm/Server.elm');

var app = Elm.Server.worker();

console.log("Hello world!");

// Send a request to elm (via ports)
app.ports.request.send("A request");
