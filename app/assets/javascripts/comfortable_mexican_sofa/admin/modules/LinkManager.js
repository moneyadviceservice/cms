define([
  'jquery',
  'DoughBaseComponent',
  'InsertManager',
  'eventsWithPromises'
], function (
  $,
  DoughBaseComponent,
  InsertManager,
  eventsWithPromises
) {
  'use strict';

  var LinkManagerProto,
      defaultConfig = {
        selectors: {
        }
      };

  function LinkManager($el, config, customConfig) {
    LinkManager.baseConstructor.call(this, $el, config, customConfig || defaultConfig);
    this.open = false;
    this.itemValues = {
      'page': null,
      'file': null,
      'external': null
    };
  }

  DoughBaseComponent.extend(LinkManager, InsertManager);

  LinkManagerProto = LinkManager.prototype;

  LinkManagerProto.init = function(initialised) {
    LinkManager.superclass.init.call(this);
    this._initialisedSuccess(initialised);
  };

  LinkManagerProto._setupAppEvents = function() {
    eventsWithPromises.subscribe('cmseditor:insert-published', $.proxy(this._handleShown, this));
    LinkManager.superclass._setupAppEvents.call(this);
  }

  return LinkManager;
});
