'use strict';

require('bootstrap/dist/css/bootstrap.css');
require('./assets/styles/style.css');
// require('font-awesome/css/font-awesome.css');

// In production don't generate index.html because that is rendered
// dynamically but we still want the static thing in development because
// it makes the development experience easier and faster
if (process.env.NODE_ENV !== 'production') {
  require('./index.html');
}

// Required for google webmaster tools site verification (and it needs to stay)
require('./assets/html/google6d01d0a1bce5c547.html');
require('./assets/images/apple-touch-icon.png');

require('./manifest.json');

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

function getSequence() {
  return Pouchdb.db.info().then(function(result) {
    return result.update_seq;
  });
}

function getDocsFromDb(db) {
  return db.allDocs({include_docs: true}).then(function(result){
    return result.rows.map(function(row){return row.doc});
  });
}

function getAllDocs() {
  // First try to load the documents from the local database
  return getDocsFromDb(Pouchdb.db).then(function(docs) {
    if (docs.length == 0) {
      // If there's nothing locally just load from the remote database directly
      return getDocsFromDb(Pouchdb.remoteDb);
    }
    else {
      return docs;
    }
  });
}

// Get sequence and all docs in parallel before we start the app
Promise.all([getSequence(), getAllDocs()]).then(function(result){
  var sequence = result[0];
  var docs = result[1];
  // Pass elm the current git version and whether it's running fullscreen
  var app = Elm.App.embed(node, {
    version: VERSION,
    standalone: standalone,
    starredCampsites: starredCampsites ? JSON.parse(starredCampsites) : null,
    online: Online.online(),
    location: location,
    docs: docs,
    sequence: sequence
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

  var Analytics = require('./js/analytics');
  Analytics.initialise(app);
});
