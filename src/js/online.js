
export function initialise(app) {
  window.addEventListener('online', function(e) {
    app.ports.online.send(true);
  }, false);

  window.addEventListener('offline', function(e) {
    app.ports.online.send(false);
  }, false);
};

export function online() {
  return navigator.onLine;
}
