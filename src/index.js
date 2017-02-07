'use strict';

require('bootstrap/dist/css/bootstrap.css');
require('./assets/styles/style.css');
// require('font-awesome/css/font-awesome.css');

// Require index.html so it gets copied to dist
require('./index.html');

require('./assets/images/apple-touch-icon.png');

var Elm = require('./elm/App.elm');

var node = document.getElementById('root');
var standalone = ("standalone" in window.navigator) && window.navigator.standalone;

var starredCampsites = localStorage.getItem('thats-camping-starred-campsites');

// Pass elm the current git version and whether it's running fullscreen
var app = Elm.App.embed(node, {
  version: VERSION,
  standalone: standalone,
  starredCampsites: starredCampsites ? JSON.parse(starredCampsites) : null,
  online: navigator.onLine
});

app.ports.storeStarredCampsites.subscribe(function(state) {
    localStorage.setItem('thats-camping-starred-campsites', JSON.stringify(state));
});

var pouchdb = require('./js/pouchdb');
pouchdb.initialise(app);

window.addEventListener('online', function(e) {
  app.ports.online.send(true);
}, false);

window.addEventListener('offline', function(e) {
  app.ports.online.send(false);
}, false);

var leaflet = require ('./js/leaflet');
leaflet.initialise(app);
