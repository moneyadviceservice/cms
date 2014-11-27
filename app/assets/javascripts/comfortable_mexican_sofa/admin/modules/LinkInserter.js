define([
  'jquery',
  'DoughBaseComponent'
], function (
  $,
  DoughBaseComponent
) {
  'use strict';

  var LinkInserterProto,
      defaultConfig = {
        uiEvents: {
          'click [data-dough-linkinserter-create]': 'insertLink'
        }
      };

  function LinkInserter($el, config) {
    LinkInserter.baseConstructor.call(this, $el, config, defaultConfig);
  }

  DoughBaseComponent.extend(LinkInserter);

  LinkInserterProto = LinkInserter.prototype;

  LinkInserterProto.init = function(initialised) {
    this._setupUIEvents();
    this._initialisedSuccess(initialised);
  };

  LinkInserterProto._setupUIEvents = function() {

  };

  return LinkInserter;
});
