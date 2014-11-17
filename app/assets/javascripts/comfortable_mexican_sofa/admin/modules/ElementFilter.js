define([
  'jquery',
  'DoughBaseComponent'
], function (
  $,
  DoughBaseComponent
) {
  'use strict';

  var ElementFilterProto,
      defaultConfig = {
        // uiEvents: {}
      };

  function ElementFilter($el, config) {
    ElementFilter.baseConstructor.call(this, $el, config, defaultConfig);
    console.log(this.config);
  }

  DoughBaseComponent.extend(ElementFilter);

  ElementFilterProto = ElementFilter.prototype;

  ElementFilterProto.init = function(initialised) {
    this._initialisedSuccess(initialised);
  };

  return ElementFilter;
});
