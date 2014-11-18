define([
  'jquery',
  'DoughBaseComponent',
  'eventsWithPromises'
], function (
  $,
  DoughBaseComponent,
  eventsWithPromises
) {
  'use strict';

  var DialogProto,
      defaultConfig = {
        // uiEvents: {}
        selectors: {
          target: '[data-dialog-target]',
          trigger: '[data-dialog-trigger]',
          container: '[data-dialog-container]',
          content: '[data-dialog-content]',
          close: '[data-dialog-close]'
        }
      };

  function Dialog($el, config) {
    Dialog.baseConstructor.call(this, $el, config, defaultConfig);
  }

  DoughBaseComponent.extend(Dialog);

  DialogProto = Dialog.prototype;

  DialogProto.init = function(initialised) {
    console.log(this.isInitialised);
    this.createElements();
    this._setupEvents();
    this._initialisedSuccess(initialised);
  };

  DialogProto.show = function() {
  };

  DialogProto.hide = function() {
  };

  DialogProto.setContent = function() {
  };

  DialogProto.onReady = function() {
  };

  DialogProto.createElements = function() {
    DialogProto.isInitialised = true;
  };

  DialogProto._setupEvents = function() {
  };

  return Dialog;
});
