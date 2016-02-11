define([
  'jquery',
  'DoughBaseComponent',
  'Collapsable',
  'eventsWithPromises'
], function (
  $,
  DoughBaseComponent,
  Collapsable,
  eventsWithPromises
) {
  'use strict';

  var SearchBarProto,
      defaultConfig = {
        selectors: {
          searchBarInput: '[data-dough-search-bar-input]'
        }
      };

  function SearchBar($el, config) {
    SearchBar.baseConstructor.call(this, $el, config, defaultConfig);
    this.context = this.$el.data('dough-search-bar-context');
  }

  DoughBaseComponent.extend(SearchBar);

  SearchBar.componentName = 'SearchBar';

  SearchBarProto = SearchBar.prototype;

  SearchBarProto.init = function(initialised) {
    this._cacheComponentElements();
    this._setupAppEvents();

    Collapsable.componentName = 'SearchBar';
    this.collapsable = new Collapsable(this.$el).init();

    this._initialisedSuccess(initialised);
  };

  SearchBarProto._setupAppEvents = function() {
    eventsWithPromises.subscribe('toggler:toggled', $.proxy(function(evt) {
      if(evt.visible && evt.emitter === this.collapsable) {
        this.focusInput();
      }
    }, this));
  };

  SearchBarProto.focusInput = function() {
    this.$searchBarInput.focus();
  };

  SearchBarProto._cacheComponentElements = function() {
    this.$searchBarInput = $('body').find(this.config.selectors.searchBarInput)
                                    .filter('[data-dough-search-bar-context="' + this.context + '"]');
  };

  return SearchBar;
});
