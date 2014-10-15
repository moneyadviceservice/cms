define(['jquery','DoughBaseComponent'], function ($, DoughBaseComponent) {
  'use strict';

  var ElementHiderProto,
      defaultConfig = {
        delay: 3000,
        selectors: {
          activeClass: 'is-active'
        },
        uiEvents: {
          'click [data-dough-element-hider-close]': 'hide'
        }
      };

  function ElementHider($el, config) {
    ElementHider.baseConstructor.call(this, $el, config, defaultConfig);
  }

  DoughBaseComponent.extend(ElementHider);
  ElementHiderProto = ElementHider.prototype;

  ElementHiderProto.init = function(initialised) {

    if(this.config.delay) {
      setTimeout($.proxy(function() {
        this.hide();
      },this), this.config.delay);
    }

    this._initialisedSuccess(initialised);

    return this;
  };

  ElementHiderProto.hide = function() {
    this.$el.removeClass(this.config.selectors.activeClass);
  };

  return ElementHider;
});
