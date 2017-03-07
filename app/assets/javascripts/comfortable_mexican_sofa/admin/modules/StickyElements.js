define([ 'jquery', 'DoughBaseComponent'], function (
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

    this._initialisedSuccess(initialised);
    this._stickyHandler();

    return this;
  };

  StickyElementsProto._stickyHandler = function() {

    var scrollElement = $(this.config.selectors.stickyElement),
        distance      = $(scrollElement).offset().top,
        $window       = $(window);

    $window.scroll(function() {
      if ( $window.scrollTop() + 10 >= distance ) {
        scrollElement.addClass('fixedsticky-on');
      } else {
        scrollElement.removeClass('fixedsticky-on');
      }
    });

  }

  return StickyElements;
});
