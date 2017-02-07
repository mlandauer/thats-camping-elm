'use strict';

require('bootstrap/dist/css/bootstrap.css');
require('leaflet/dist/leaflet.css');
require('leaflet/dist/images/marker-shadow.png');
require('leaflet/dist/images/marker-icon-2x.png');
require('./assets/styles/style.css');
// require('font-awesome/css/font-awesome.css');

// Require index.html so it gets copied to dist
require('./index.html');

require('./assets/images/apple-touch-icon.png');

var L = require('leaflet');

var PouchDB = require('pouchdb');

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

var db = new PouchDB('thats-camping');

var remoteDb = new PouchDB('https://mlandauer.cloudant.com/thats-camping', {
  auth: {
    // We're just using these tokens to get access to the remote database
    // temporarily.
    // TODO: Generate new tokens and remove from source code
    username: 'cirtionewessinstroonheen',
    password: '5e5308b9016a700156164970fbb346f9ede08e8e'
  }
});

db.sync(remoteDb, {live: true, retry: true}).on('change', function (info) {
  console.log("sync change:", info);
}).on('paused', function (err) {
  // replication paused (e.g. replication up to date, user went offline)
  console.log("sync paused:", err);
}).on('active', function () {
  // replicate resumed (e.g. new changes replicating, user went back online)
  console.log("sync active");
}).on('denied', function (err) {
  // a document failed to replicate (e.g. due to permissions)
  console.log("sync denied:", err);
}).on('complete', function (info) {
  // handle complete
  console.log("sync complete:", info);
}).on('error', function (err) {
  // handle error
  console.log("sync error:", err);
});

db.changes({
  live: true,
  include_docs: true
}).on('change', function(change) {
  app.ports.change.send(change);
}).on('complete', function(info) {
  // TODO: Send this to a port
  console.log("complete", info);
}).on('error', function (err) {
  // TODO: Send this to a port
  console.log("error", err);
});

app.ports.put.subscribe(function(data) {
  db.put(data)
    .then(function(response) {
      app.ports.putSuccess.send(response);
    })
    .catch(function (err) {
      if (err instanceof Error) {
        app.ports.putError.send({status: null, name: null, message: err.message, error: true});
      } else {
        app.ports.putError.send(err.message);
      }
    });
});

app.ports.destroy.subscribe(function(_) {
  db.destroy().then(function (response) {
    app.ports.destroySuccess.send(response);
  }).catch(function (err) {
    app.ports.destroyError.send(err);
  });
});

app.ports.bulkDocs.subscribe(function(data) {
  db.bulkDocs(data)
    .then(function(response) {
      console.log(response);
    }).catch(function(err) {
      console.log(err);
    });
});

window.addEventListener('online', function(e) {
  app.ports.online.send(true);
}, false);

window.addEventListener('offline', function(e) {
  app.ports.online.send(false);
}, false);

var map = undefined;
var mapMarkers = {};

/* Starting point is 32° 09' 48" South, 147° 01' 00" East which is "centre" of NSW */
map = L.map('map').setView([-32.163333333333334, 147.01666666666668], 9);

L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    maxZoom: 18,
    id: 'mapbox.streets',
    accessToken: 'pk.eyJ1IjoibWxhbmRhdWVyIiwiYSI6ImNpeXVzZ2c5djAxb28zM281amZ1emxmcHUifQ.dThcfHRKKNQckFMkCyObJw'
}).addTo(map);

app.ports.mapVisibility.subscribe(function(visibility) {
  if (visibility) {
    document.getElementById('map-wrapper').style.display = "";
    /* Need to call map.invalidateSize() after re-showing hidden map. See
       https://github.com/Leaflet/Leaflet/issues/2738 */
    if (map) {
      map.invalidateSize();
    }
  } else {
    document.getElementById('map-wrapper').style.display = "none";
  }
});

app.ports.panMapTo.subscribe(function(location) {
  map.panTo([location.latitude, location.longitude]);
});

app.ports.setMarker.subscribe(function(marker) {
  if (marker.id in mapMarkers) {
    /* If marker already exists just update the location */
    var m = mapMarkers[marker.id];
    m.setLatLng([marker.location.latitude, marker.location.longitude]);
  } else {
    /* If it's a new marker, create it and add it to the map */
    var m = L.marker([marker.location.latitude, marker.location.longitude]);
    mapMarkers[marker.id] = m;
    m.addTo(map);
  }
});
