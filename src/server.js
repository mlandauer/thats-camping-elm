var Elm = require('./elm/Server.elm');

var app = Elm.Server.worker();

// Send a request to elm (via ports)
app.ports.request.send(null);

app.ports.response.subscribe(function(response) {
  console.log("response:", response);
});
