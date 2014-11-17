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
        selectors: {
          activeClass: 'is-active',
          trigger: '[data-dough-element-filter-trigger]',
          target: '[data-dough-element-filter-target]'
        },
        uiEvents: {}
      };

  function ElementFilter($el, config) {
    ElementFilter.baseConstructor.call(this, $el, config, defaultConfig);
    this.$trigger = this.$el;
    this.$target = $('[data-dough-element-filter-target="' + this.$trigger.attr('data-dough-element-filter-trigger') + '"]');
    this.$filterableItems = this.$target.children().filter('[data-dough-element-filter-item="true"]');
    this._handleClick = $.proxy(this._handleClick, this);
  }

  DoughBaseComponent.extend(ElementFilter);

  ElementFilterProto = ElementFilter.prototype;

  ElementFilterProto.init = function(initialised) {
    this._setupEventListeners();
    this._initialisedSuccess(initialised);
  };

  ElementFilterProto._setupEventListeners = function() {
    $('body').on('click touchend', defaultConfig.selectors.trigger, this._handleClick);
  };

  ElementFilterProto._handleClick = function() {
    this.toggle();
  };

  ElementFilterProto.toggle = function() {
    this.$filterableItems.toggleClass(this.config.selectors.activeClass);
  };

  return ElementFilter;
});
