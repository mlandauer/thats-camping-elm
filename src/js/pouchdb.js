var PouchDB = require('pouchdb');

// Setting window.PouchDB so that we can use the Chrome PouchDB inspector
// https://chrome.google.com/webstore/detail/pouchdb-inspector/hbhhpaojmpfimakffndmpmpndcmonkfa
window.PouchDB = PouchDB;

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

export function initialise(app) {
  app.ports.sync.subscribe(function(options){
    db.sync(remoteDb, options).on('change', function (info) {
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
  });

  app.ports.changes.subscribe(function(options){
    db.changes(options).on('change', function(change) {
      app.ports.changeSuccess.send(change);
    }).on('complete', function(info) {
      if ("status" in info) {
        app.ports.changeComplete.send(
          {results: null, last_seq: null, status: info.status});
      } else {
        app.ports.changeComplete.send(
          {results: info.results, last_seq: info.last_seq, status: null});
      }
    }).on('error', function (err) {
      // TODO: Send this to a port
      console.log("error", err);
    });

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
};
