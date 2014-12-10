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
        },
        tabIds: {
          'page': 'page',
          'file': 'file',
          'external': 'external'
        }
      };

  function LinkManager($el, config) {
    LinkManager.baseConstructor.call(this, $el, config, defaultConfig);
    this.open = false;
    this.linkValues = {
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

  return LinkManager;
});
