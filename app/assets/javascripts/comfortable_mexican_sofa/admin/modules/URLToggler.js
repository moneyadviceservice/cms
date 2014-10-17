define([
  'jquery',
  'DoughBaseComponent'
], function (
  $,
  DoughBaseComponent
) {
  'use strict';

  var URLTogglerProto,
      defaultConfig = {
        uiEvents: {
          'change ': '_handleChange'
        }
      };

  function URLToggler($el, config) {
    URLToggler.baseConstructor.call(this, $el, config, defaultConfig);
  }

  DoughBaseComponent.extend(URLToggler);

  URLTogglerProto = URLToggler.prototype;

  URLTogglerProto.init = function(initialised) {
    this._initialisedSuccess(initialised);
  };

  URLTogglerProto._handleChange = function() {
    window.location = this.$el.find(':checked').data()['value'];
  };

  return URLToggler;
});
