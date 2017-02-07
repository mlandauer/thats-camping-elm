var L = require('leaflet');

require('leaflet/dist/leaflet.css');
require('leaflet/dist/images/marker-shadow.png');
require('leaflet/dist/images/marker-icon-2x.png');

var map = undefined;
var mapData = {};

export function initialise(app, centre) {
  map = L.map('map').setView(centre, 9);

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

  app.ports.setMapMarker.subscribe(function(marker) {
    if (marker.id in mapData) {
      /* If marker already exists just update the location */
      var m = mapData[marker.id].marker;
      m.setLatLng([marker.location.latitude, marker.location.longitude]);
      m.setPopupContent(marker.html)
    } else {
      /* If it's a new marker, create it and add it to the map */
      var m = L.marker([marker.location.latitude, marker.location.longitude]);
      var p = L.popup(m);
      mapData[marker.id] = {marker: m};
      m.addTo(map);
      m.bindPopup(marker.html)
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
