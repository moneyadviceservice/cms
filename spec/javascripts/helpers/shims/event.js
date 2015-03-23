// Shims Event()
// Taken from https://github.com/Raynos/DOM-shim/blob/master/src/all/interfaces/Event.js
window.Event = function(type, dict) {
  var e = document.createEvent("Events");
  dict = dict || {};
  dict.bubbles = dict.bubbles || false;
  dict.catchable = dict.catchable || false;
  e.initEvent(type, dict.bubbles, dict.catchable);
  return e;
};
