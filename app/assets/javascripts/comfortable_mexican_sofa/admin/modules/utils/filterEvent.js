define([],
function () {
  'use strict';

  // Filters event based on the context
  // filterEvent(function(eventData) {}, 'foo')

  return function(fn, context) {
    return function(eventData) {
      return eventData.emitter === context && fn(eventData);
    }
  };
});
