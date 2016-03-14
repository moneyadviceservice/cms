define([
  'jquery',
  'DoughBaseComponent'
], function (
  $,
  DoughBaseComponent
) {
  'use strict';

  var RemoverProto,
      defaultConfig = {
        selectors: {
          removeButton: '[data-dough-dialog-trigger=remover]'
        }
      };

  function Remover($el, config) {
    Remover.baseConstructor.call(this, $el, config, defaultConfig);
  }

  DoughBaseComponent.extend(Remover);

  Remover.componentName = 'Remover';

  RemoverProto = Remover.prototype;

  RemoverProto.init = function(initialised) {
    this._cacheComponentElements();
    this._setupUIEvents();
    this._initialisedSuccess(initialised);
  };

  RemoverProto._cacheComponentElements = function() {
    this.$removeButton  = $(this.config.selectors.removeButton);
  };

  RemoverProto._setupUIEvents = function() {
    this.$removeButton.on('click', $.proxy(this._preventFormSubmission, this));
  };

  RemoverProto._preventFormSubmission = function(e) {
    e.preventDefault();
  };

  return Remover;
});
