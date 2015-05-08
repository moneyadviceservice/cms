define([
  'jquery',
  'DoughBaseComponent'
], function (
  $,
  DoughBaseComponent
) {
  'use strict';

  var MirrorInputValueProto,
      defaultConfig = {
        selectors: {
          triggerInput : '[data-dough-mirrorinputvalue-trigger]',
          targetInput : '[data-dough-mirrorinputvalue-target]'
        },
        uiEvents: {
          'keyup [data-dough-mirrorinputvalue-trigger]': '_handleTriggerKeyup',
          'keyup [data-dough-mirrorinputvalue-target]': '_handleTargetKeyup'
        }
      };

  function MirrorInputValue($el, config) {
    MirrorInputValue.baseConstructor.call(this, $el, config, defaultConfig);
  }

  DoughBaseComponent.extend(MirrorInputValue);

  MirrorInputValue.componentName = 'MirrorInputValue';

  MirrorInputValueProto = MirrorInputValue.prototype;

  MirrorInputValueProto.init = function(initialised) {
    this._cacheComponentElements();
    this._initialisedSuccess(initialised);
  };

  MirrorInputValueProto._cacheComponentElements = function() {
    this.$triggerInput = this.$el.find(this.config.selectors.triggerInput);
    this.$targetInput = this.$el.find(this.config.selectors.targetInput);
  };

  MirrorInputValueProto._handleTriggerKeyup = function() {
    this.$targetInput.val(this.$triggerInput.val()).trigger('input');
  };

  MirrorInputValueProto._handleTargetKeyup = function(e) {
    if(e.keyCode === 9) return;
    this.destroy();
  };

  return MirrorInputValue;
});
