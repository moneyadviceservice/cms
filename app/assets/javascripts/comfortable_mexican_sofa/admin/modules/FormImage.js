/**
 *  FormImage component
 *  - Listens for an image to be selected by the insert-image dialog
 *  - Populates a hidden text input field [data-dough-form-image-input]
 *  - Shows a thumbnail preview image
 *  - The button which launches the image browser should have 
 *    - [data-dough-component="Dialog"]
 *    - [data-dough-dialog-context="insert-image"]
 *    - [data-dough-dialog-identifier="<unique-id>"]
 *    - [data-dough-form-image-trigger]
 */
window.define([
  'jquery',
  'DoughBaseComponent',
  'eventsWithPromises',
  'filter-event'
], 
function ($, DoughBaseComponent, eventsWithPromises, filterEvent) {
  'use strict';

  var FormImageProto,
      defaultConfig = {
        context: 'insert-image',
        selectors: {
          identifier: '[data-dough-form-image-identifier]',
          input: '[data-dough-form-image-input]',
          button: '[data-dough-form-image-trigger]',
          imageLink: 'form-image__image-link',
          removeButton: 'form-image__button--remove',
          previewContainer: 'form-image__preview',
          previewContainerWrapper: 'form-image__preview-wrapper',
          imageSelected: 'form-image--image-selected'
        }
      };

  function FormImage($el, config) {
    FormImage.baseConstructor.call(this, $el, config, defaultConfig);
  }

  DoughBaseComponent.extend(FormImage);
  FormImage.componentName = 'FormImage';
  FormImageProto = FormImage.prototype;

  FormImageProto.init = function(initialised) {
    this._cacheElements();
    this.identifier = this.$el.attr(this._stripSquareBrackets(this.config.selectors.identifier));
    this._setupUIEvents();
    this._setupAppEvents();
    this._showThumbnail(this.elements.$input.attr('value')); // There may be a URL saved already
    this._initialisedSuccess(initialised);
  };

  FormImageProto._cacheElements = function() {
    this.elements = {
      $previewContainer: this.$el.find('.' + this.config.selectors.previewContainer),
      $input: this.$el.find(this.config.selectors.input),
      $button: this.$el.find(this.config.selectors.button)
    };
  };

  FormImageProto._showThumbnail = function(imageUrl) {
    if(!imageUrl) {
      return;
    }

    this.$el.find('.' + this.config.selectors.imageLink).remove();
    this.$el.addClass(this.config.selectors.imageSelected);

    $('<a/>', {
      style: 'background-image: url(' + imageUrl + ')',
      class: this.config.selectors.imageLink,
      href: imageUrl,
      target: '_blank'
    }).appendTo(this.elements.$previewContainer);
  };

  FormImageProto._handleImageSelected = function(imageData) {
    var image,
        div;

    if(this.identifier !== this.dialogIdentifier) {
      return;
    }

    div = document.createElement('div');
    div.innerHTML = imageData.val; // An image tag string
    image = div.childNodes[0];      
    this.elements.$input.attr('value', image.src);
    this._showThumbnail(image.src);
  };

  FormImageProto._handleDialogShown = function(data) {
    this.dialogIdentifier = data.identifier;
  };

  FormImageProto._handleRemoveImage = function() {
    this.$el.find('.' + this.config.selectors.imageLink).remove();
    this.elements.$input.attr('value', '');
    this.$el.removeClass(this.config.selectors.imageSelected);
  };

  FormImageProto._setupUIEvents = function() {
    this.$el.on('click', '.' + this.config.selectors.removeButton, $.proxy(this._handleRemoveImage, this));
  };

  FormImageProto._setupAppEvents = function() {
    eventsWithPromises.subscribe('insertmanager:insert-published', filterEvent($.proxy(this._handleImageSelected, this), this.config.context));
    eventsWithPromises.subscribe('dialog:shown', filterEvent($.proxy(this._handleDialogShown, this), this.config.context));
  };

  FormImageProto._stripSquareBrackets = function(str) {
    return str.replace(/([\[\]])+/gi,'');
  };

  return FormImage;
});
