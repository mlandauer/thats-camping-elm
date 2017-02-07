'use strict';

require('bootstrap/dist/css/bootstrap.css');
require('./assets/styles/style.css');
// require('font-awesome/css/font-awesome.css');

// Require index.html so it gets copied to dist
require('./index.html');

require('./assets/images/apple-touch-icon.png');

var Elm = require('./elm/App.elm');
var Online = require('./js/online');
var Pouchdb = require('./js/pouchdb');
var Leaflet = require ('./js/leaflet');

var node = document.getElementById('root');
var standalone = ("standalone" in window.navigator) && window.navigator.standalone;

var starredCampsites = localStorage.getItem('thats-camping-starred-campsites');
var location = localStorage.getItem('thats-camping-location');
if (location) {
  location = JSON.parse(location)
}
// Pass elm the current git version and whether it's running fullscreen
var app = Elm.App.embed(node, {
  version: VERSION,
  standalone: standalone,
  starredCampsites: starredCampsites ? JSON.parse(starredCampsites) : null,
  online: Online.online(),
  location: location
});

app.ports.storeStarredCampsites.subscribe(function(state) {
    localStorage.setItem('thats-camping-starred-campsites', JSON.stringify(state));
});

app.ports.storeLocation.subscribe(function(state) {
    localStorage.setItem('thats-camping-location', JSON.stringify(state));
});

Online.initialise(app);
Pouchdb.initialise(app);

/* We need to tell the map what to initially centre on */
if (location) {
  var centre = [location.latitude, location.longitude]
} else {
  /* Starting point is 32° 09' 48" South, 147° 01' 00" East which is "centre" of NSW */
  var centre = [-32.163333333333334, 147.01666666666668]
}
Leaflet.initialise(app, centre);
