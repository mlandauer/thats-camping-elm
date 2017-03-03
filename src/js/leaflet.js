var L = require('leaflet');
var jQuery = require("jquery");

require('leaflet/dist/leaflet.css');
require('leaflet/dist/images/marker-shadow.png');
require('leaflet/dist/images/marker-icon-2x.png');

var map = undefined;
var mapMarkers = {};

var starIcon = L.divIcon({className: 'map-star-icon', html: "<span class=\"glyphicon glyphicon-star\"></span>"});

export function initialise(app, center) {
  var mapboxUrl =
    'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}';
  var mapboxAttribution =
    'Map data <a href="http://openstreetmap.org">OpenStreetMap</a>, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery <a href="http://mapbox.com">Mapbox</a>';
  var mapboxAccessToken =
    'pk.eyJ1IjoibWxhbmRhdWVyIiwiYSI6ImNpeXVzZ2c5djAxb28zM281amZ1emxmcHUifQ.dThcfHRKKNQckFMkCyObJw';

  map = L.map('map', {
    center: center,
    zoom: 9,
  });

  L.tileLayer(mapboxUrl, {
    attribution: mapboxAttribution,
    maxZoom: 18,
    id: 'mapbox.streets',
    accessToken: mapboxAccessToken
  }).addTo(map);

  L.control.scale({imperial: false, position: 'topright'}).addTo(map);

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

  app.ports.createMarker.subscribe(function(marker){
    // TODO: Guard against this not actually being a new marker
    // if (marker.icon == 0) {
      var m = L.marker([marker.location.latitude, marker.location.longitude]);
    // } else {
    //   var m = L.marker([marker.location.latitude, marker.location.longitude],
    //     {icon: starIcon});
    // }
    mapMarkers[marker.id] = m;
    m.addTo(map);
    // This is the only use of jquery. Ugh. Using it to attach an
    // event handler
    var html = jQuery(marker.html).click(function() {
      app.ports.markerClicked.send(marker.id);
      return false;
    })[0];
    m.bindPopup(html, {closeButton: false});
  });

  app.ports.updateMarker.subscribe(function(marker){
    var m = mapMarkers[marker.id];
    m.setLatLng([marker.location.latitude, marker.location.longitude]);
    // This is the only use of jquery. Ugh. Using it to attach an
    // event handler
    var html = jQuery(marker.html).click(function() {
      app.ports.markerClicked.send(marker.id);
      return false;
    })[0];
    // Setting the contents of the popup shifts the popup to the right.
    // Calling m.getPopup().update() or m.update() doesn't do anything to fix
    // this. I'm guessing at this stage it's a bug in leaflet but don't really
    // know for sure. Anyway, let's minimise the effect of it by only updating
    // the content of the popup if it's actually necessary (i.e. the content has
    // changed!)
    // TODO: Fix bug with shift to the right after content update
    if (m.getPopup().getContent().outerHTML != html.outerHTML) {
      m.setPopupContent(html);
    }
  });

  /*
     A nasty hack to deal with the display of the map in "standalone". because
     the "fullscreen" class on the top level div of the application is managed
     by elm and the map sits outside of this (to work around current limitations
     of elm interopability with javascript frameworks like leaflet) we need to
     set a similar class in plain javascript so that the maps is in the right
     place on a fullscreen mobile app. It's nasty and it offends me to do the
     same thing twice in different ways but we'll have to live with it for the
     time being.
  */

  if (("standalone" in window.navigator) && window.navigator.standalone) {
    document.getElementById("map-wrapper").className += " fullscreen";
  }
}
