var path = require("path");
var AppCachePlugin = require('appcache-webpack-plugin');
var GitRevisionPlugin = require('git-revision-webpack-plugin');
var webpack = require('webpack');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var gitRevisionPlugin = new GitRevisionPlugin();

// TODO: Remove duplication between clientConfig and serverConfig

clientConfig = {
  entry: {
    app: [
      './src/index.js'
    ]
  },
  output: {
    path: path.resolve(__dirname + '/docs'),
    filename: '[name].js',
  },

  module: {
    rules: [
      {
        test: /\.(css|scss)$/,
        loader: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: "css-loader?sourceMap",
        })
      },
      {
        test:    /\.(html|png)$/,
        use:  'file-loader?name=[name].[ext]',
      },
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use:  'elm-webpack-loader?verbose=true&warn=true',
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        use: 'url-loader?limit=10000&mimetype=application/font-woff',
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        use: 'file-loader',
      },
    ],

    noParse: /\.elm$/,
  },

  devtool: 'source-map',

  devServer: {
    inline: true,
    stats: { colors: true },
  },

  plugins: [
    new AppCachePlugin({cache: ["/", "/campsites"], exclude: ['index.html']}),
    new GitRevisionPlugin(),
    new webpack.DefinePlugin({
      'VERSION': JSON.stringify(gitRevisionPlugin.version())
    }),
    new ExtractTextPlugin('app.css')
  ]
};

serverConfig = {
  entry: {
    server: [
      './src/server.js'
    ]
  },
  target: 'node',
  output: {
    path: path.resolve(__dirname + '/docs'),
    filename: '[name].js',
  },

  module: {
    rules: [
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use:  'elm-webpack-loader?verbose=true&warn=true',
      },
    ],

    noParse: /\.elm$/,
  },
  externals: {
    'pouchdb':"require('pouchdb')",
  },

  devtool: 'source-map',

  plugins: [
    new GitRevisionPlugin(),
    new webpack.DefinePlugin({
      'VERSION': JSON.stringify(gitRevisionPlugin.version())
    })
  ]
};

module.exports = [clientConfig, serverConfig];
