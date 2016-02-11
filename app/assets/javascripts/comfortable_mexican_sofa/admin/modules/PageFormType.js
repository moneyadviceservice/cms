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

  PageFormTypeProto._selectEventListener = function(event) {
    this.$el.on('change', $.proxy(this._selectEventChange, this) );
  };

  PageFormTypeProto._selectEventChange = function() {
    this._formTypeVariables();

    $forms.hide();

    if($form.length > 0) {
      $forms.hide();
      $form.show();
    } else {
      $forms.hide();
      $defaultEditor.show();
    };
  };

  return PageFormType;
});
