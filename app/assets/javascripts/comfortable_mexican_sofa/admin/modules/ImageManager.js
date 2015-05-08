define([
  'jquery',
  'DoughBaseComponent',
  'InsertManager'
], function (
  $,
  DoughBaseComponent,
  InsertManager
) {
  'use strict';

  var ImageManagerProto,
      defaultConfig = {
        selectors: {}
      };

  function ImageManager($el, config) {
    ImageManager.baseConstructor.call(this, $el, config, defaultConfig);
    this.open = false;
    this.itemValues = {};
  }

  DoughBaseComponent.extend(ImageManager, InsertManager);

  ImageManager.componentName = 'ImageManager';

  ImageManagerProto = ImageManager.prototype;

  ImageManagerProto.init = function(initialised) {
    ImageManager.superclass.init.call(this);
    this._initialisedSuccess(initialised);
  };

  return ImageManager;
});
