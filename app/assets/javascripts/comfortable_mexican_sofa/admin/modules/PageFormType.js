define(['jquery','DoughBaseComponent'], function ($, DoughBaseComponent) {
  'use strict';

  var PageFormTypeProto,
      pageType,
      $form,
      $forms,
      $defaultEditor;

  function PageFormType($el) {

  	PageFormType.baseConstructor.call(this, $el);

  }

  DoughBaseComponent.extend(PageFormType);

  PageFormType.componentName = 'PageFormType';

  PageFormTypeProto = PageFormType.prototype;

  PageFormTypeProto.init = function(initialised) {

    this._formTypeVariables();
    this._formTypeDisplay();
    this._selectEventListener();

    this._initialisedSuccess(initialised);
    return this;

  };

  PageFormTypeProto._formTypeVariables = function() {

    pageType       = this.$el.find(':selected').data('dough-urlformatter-page-type-value');
    $forms         = $('[data-main-form]'),
    $form          = $('[data-main-form="' + pageType + '"]'),
    $defaultEditor = $('[data-main-form="default-editor"]');

  };

  PageFormTypeProto._formTypeDisplay = function() {

    if($form.length > 0) {
      $forms.hide();
      $form.show();
    } else {
      $forms.hide();
      $defaultEditor.show();
    };

    console.log('You have loaded the page with a ' + pageType + ' form');

  };

  PageFormTypeProto._selectEventListener = function(event) {

    this.$el.on('change', this._selectEventChange);

  };

  PageFormTypeProto._selectEventChange = function() {

    pageType = $(this).find(':selected').data('dough-urlformatter-page-type-value'),
    $forms   = $('[data-main-form]'),
    $form    = $('[data-main-form="' + pageType + '"]'),
    $defaultEditor = $('[data-main-form="default-editor"]');

    $forms.hide();

    if($form.length > 0) {
      $forms.hide();
      $form.show();
    } else {
      $forms.hide();
      $defaultEditor.show();
    };

    console.log('You have change the page type to a ' + pageType + ' form')

  };

  return PageFormType;

});
