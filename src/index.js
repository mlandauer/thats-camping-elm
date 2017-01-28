'use strict';

require('./style.css');
// require('font-awesome/css/font-awesome.css');

// Require index.html so it gets copied to dist
require('./index.html');

require('./apple-touch-icon.png');

var Elm = require('./App.elm');

var node = document.getElementById('root');
var app = Elm.App.embed(node);
