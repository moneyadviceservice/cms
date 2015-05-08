define([
  'jquery',
  'DoughBaseComponent',
  'filament-sticky'
], function (
  $,
  DoughBaseComponent
) {
  'use strict';

  var StickyElementsProto,
      defaultConfig = {
        selectors: {
          stickyElement: '[data-dough-sticky-element-target]'
        }
      };

  function StickyElements($el, config) {
    StickyElements.baseConstructor.call(this, $el, config, defaultConfig);
  }

  DoughBaseComponent.extend(StickyElements);

  StickyElements.componentName = 'StickyElements';

  StickyElementsProto = StickyElements.prototype;

  StickyElementsProto.init = function(initialised) {
    $(this.config.selectors.stickyElement).fixedsticky();
    this._initialisedSuccess(initialised);
  };

  return StickyElements;
});
