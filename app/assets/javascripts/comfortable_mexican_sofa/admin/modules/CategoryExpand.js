define(['jquery','DoughBaseComponent'], function ($, DoughBaseComponent) {
'use strict';

  var defaultConfig = {
    categoriesCharacterDelimiter: ','
  },
  CategoryExpandProto,
  $cells;

  function CategoryExpand($el, config) {

    CategoryExpand.baseConstructor.call(this, $el, config, defaultConfig);

  }

  DoughBaseComponent.extend(CategoryExpand);

  CategoryExpand.componentName = 'CategoryExpand';

  CategoryExpandProto = CategoryExpand.prototype;

  CategoryExpandProto.init = function(initialised) {

    this._initialiseVariables();
    this._initialiseCells();
    this._addAjaxListeners();
    this._addUIEventListeners();

    this._initialisedSuccess(initialised);
    return this;

  };

  CategoryExpandProto._initialiseVariables = function() {

    $cells = this.$el.find('.categories');

  };

  CategoryExpandProto._addAjaxListeners = function() {

    $('#filter_form').on('ajax:complete', $.proxy( this._ajaxCompleteHandler, this));
    $('#filter_form').on('ajax:beforeSend', $.proxy( this._ajaxBeforeSendHandler, this));

  };

  CategoryExpandProto._addUIEventListeners = function() {

    $cells.on('click', this._cellsClickHandler);

  };

  CategoryExpandProto._removeUIEventListeners = function() {

    $cells.off('click', this._cellsClickHandler);

  };

  CategoryExpandProto._initialiseCells = function() {

    var self = this;

    $cells.each(function() {

      var $currentCell = $(this),
      cellText = $currentCell.text(),
      categoryArray = cellText.split(self.config.categoriesCharacterDelimiter),
      categoryCount = categoryArray.length,
      cellData = {
        '$currentCell' : $currentCell,
        'cellText' : cellText,
        'categoryArray' : categoryArray,
        'categoryCount' : categoryCount
      };

      if (cellData.categoryCount > 1) {
        self._addExpanders(cellData);
      };

    });

  };

  CategoryExpandProto._addExpanders = function(cellData) {

    var delim = this.config.categoriesCharacterDelimiter;
    var firstCategory = cellData.categoryArray.splice(0, 1)[0];
    var numberOtherCategories = cellData.categoryCount - 1;
    var otherCategoriesText = cellData.categoryArray.join(delim);

    cellData.$currentCell.html(
          firstCategory +
          ' <div><a href="#" class="more">+' + numberOtherCategories + ' more</a>' +
          '<span style="display:none;" class="allCategories">'+ otherCategoriesText +
          ' <a href="#" class="less">Hide</a></span></div>'
        );

  };

  CategoryExpandProto._ajaxBeforeSendHandler = function(evt) {

    this._removeUIEventListeners();

  };

  CategoryExpandProto._ajaxCompleteHandler = function(evt) {

      this._initialiseVariables();
      this._initialiseCells();
      this._addUIEventListeners();

  };

  CategoryExpandProto._cellsClickHandler = function(evt) {

    var $currentCell = $(evt.currentTarget),
    $targetButton = $(evt.target),
    $more = $currentCell.find('.more'),
    $less = $currentCell.find('.less'),
    $otherCategories = $currentCell.find('.allCategories');

    if($targetButton.hasClass('more')) {
      evt.preventDefault();
      $more.hide();
      $otherCategories.show();
    }
    else if($targetButton.hasClass('less')) {
      evt.preventDefault();
      $otherCategories.hide();
      $more.show();
    }

  };

  return CategoryExpand;

});



