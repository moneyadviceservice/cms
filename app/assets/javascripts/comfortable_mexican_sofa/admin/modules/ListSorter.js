define([
  'jquery',
  'DoughBaseComponent',
  'html-sortable'
], function (
  $,
  DoughBaseComponent
) {
  'use strict';

  var ListSorterProto,
      defaultConfig = {
        selectors: {
          listOrderfield: 'data-dough-listsorter-order-field',
          itemId: 'data-dough-listsorter-item-id',
          context: 'data-dough-listsorter-context'
        }
      };

  function ListSorter($el, config) {
    ListSorter.baseConstructor.call(this, $el, config, defaultConfig);
  }

  DoughBaseComponent.extend(ListSorter);

  ListSorterProto = ListSorter.prototype;

  ListSorterProto.init = function(initialised) {
    this.$el.sortable().bind('sortupdate', $.proxy(this._handleListUpdate, this));
    this._cacheComponentElements();
    this.updateOrderFields();
    this._initialisedSuccess(initialised);
  };

  ListSorterProto._cacheComponentElements = function() {
    this.$listOrderFields = $('[' + this.config.selectors.listOrderfield + '][' + this.config.selectors.context + '=' + this.$el.attr(this.config.selectors.context) + ']');
  };

  ListSorterProto._handleListUpdate = function() {
    this.updateOrderFields();
  };

  ListSorterProto.getListOrderArray = function() {
    var arr = [],
        _this = this;

    $.each(this.$el.find('[' + this.config.selectors.itemId + ']'), function() {
      return arr.push($(this).attr(_this.config.selectors.itemId));
    });

    return arr;
  };

  ListSorterProto.setOrderFieldValue = function(val) {
    this.$listOrderFields.val(val);
  };

  ListSorterProto.updateOrderFields = function() {
    this.setOrderFieldValue('[' + this.getListOrderArray() + ']');
  };

  return ListSorter;
});
