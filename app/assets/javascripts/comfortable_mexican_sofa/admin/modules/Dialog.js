define([
  'dialog-polyfill',
  'jquery',
  'DoughBaseComponent',
  'eventsWithPromises'
], function (
  dialogPolyfill,
  $,
  DoughBaseComponent,
  eventsWithPromises
) {
  'use strict';

  var DialogProto,
      defaultConfig = {
        uiEvents: {
          'click': 'show'
        },
        selectors: {
          dialog: '[data-dough-dialog]',
          target: '[data-dough-dialog-target]',
          trigger: '[data-dough-dialog-trigger]',
          container: '[data-dough-dialog-container]',
          containerInner: '[data-dough-dialog-container-inner]',
          content: '[data-dough-dialog-content]',
          contentInner: '[data-dough-dialog-content-inner]',
          close: '[data-dough-dialog-close]',
          activeClass: 'is-active',
          inactiveClass: 'is-inactive',
          dialogOpenBodyClass: 'js-dialog-active'
        }
      };

  function Dialog($el, config) {
    Dialog.baseConstructor.call(this, $el, config, defaultConfig);
    this.isShown = false;
  }

  DoughBaseComponent.extend(Dialog);

  DialogProto = Dialog.prototype;

  DialogProto.init = function(initialised) {
    this.context = this.$el.attr('data-dough-dialog-context');
    this._cacheComponentElements();
    this._setupDialog();
    this._setupUIEvents();
    this._setupAppEvents();
    this._initialisedSuccess(initialised);
  };

  DialogProto._cacheComponentElements = function() {
    this.$trigger = this.$el;
    this.$target = $('[data-dough-dialog-target="' + this.$trigger.attr('data-dough-dialog-trigger') + '"]');
  };

  DialogProto._setupDialog = function() {
    this.$dialog = $('<dialog data-dough-dialog class="dialog is-inactive" />');
    this.$dialogContainer = $('<div data-dough-dialog-container class="dialog__container" />');
    this.$dialogContainerInner = $('<div data-dough-dialog-container-inner class="dialog__container-inner" />');
    this.$dialogContent = $('<div data-dough-dialog-content class="dialog__content" />');
    this.$dialogContentInner = $('<div data-dough-dialog-content-inner class="dialog__content-inner" />');
    this.$dialogClose = $('<button data-dough-dialog-close class="dialog__close"><span class="dialog__close-text visually-hidden">Close</span></button>');
    this.$dialog
      .appendTo('body')
      .append(this.$dialogContainer);

    this.$dialogContainer.append(this.$dialogContainerInner);
    this.$dialogContainerInner.append(this.$dialogContent);
    this.$dialogContent.append(this.$dialogContentInner);
    this.$dialogContentInner.append(this.$dialogClose);
    this.dialog = this.$dialog[0];

    if(typeof window.HTMLDialogElement === 'undefined') {
      dialogPolyfill.registerDialog(this.dialog);
    }
  };

  DialogProto._setupUIEvents = function() {
    this.$dialog
      .on('click', this.config.selectors.close, $.proxy(this.close, this, false))
      .on('cancel', $.proxy(this._handleCancel, this));
  };

  DialogProto._setupAppEvents = function() {
    eventsWithPromises.subscribe('dialog:close', $.proxy(this._handleClose, this));
    eventsWithPromises.subscribe('dialog:show', $.proxy(function(eventData) {
      this.show(eventData && eventData.showModal || false);
    }, this));
  };

  DialogProto._handleCancel = function() {
    this.close(true);
  };

  DialogProto._handleClose = function(eventData) {
    console.log(eventData);
    if(eventData && eventData.emitter === this.context) {
      this.close();
    }
  };

  DialogProto._detachTarget = function() {
    this.$locationMarker = $('<span />').insertBefore(this.$target);
    this.$target.detach();
  };

  DialogProto._attachTarget = function() {
    this.$target.insertBefore(this.$locationMarker);
    this.$locationMarker.remove();
  };

  DialogProto.show = function(showModal) {
    if(this.isShown) return;

    this._detachTarget();
    this.appendTargetToDialog(this.$target);
    showModal? this.dialog.showModal() : this.dialog.show();

    this.$dialog
      .removeClass(this.config.selectors.inactiveClass)
      .addClass(this.config.selectors.activeClass);

    this.$target
      .removeClass(this.config.selectors.inactiveClass)
      .addClass(this.config.selectors.activeClass);

    $('body').addClass(this.config.selectors.dialogOpenBodyClass);

    this.isShown = true;

    eventsWithPromises.publish('dialog:shown', {
      emitter: this.context,
      modal: showModal
    });
  };

  DialogProto.close = function(cancelled) {
    if(!this.isShown) return;

    if(!cancelled) {
      this.dialog.close();
    }

    this._attachTarget();

    this.$dialog
      .addClass(this.config.selectors.inactiveClass)
      .removeClass(this.config.selectors.activeClass);

    this.$target
      .removeClass(this.config.selectors.activeClass)
      .addClass(this.config.selectors.inactiveClass);

    $('body').removeClass(this.config.selectors.dialogOpenBodyClass);

    this.isShown = false;

    eventsWithPromises.publish('dialog:closed', {
      emitter: this.context
    });

    if(cancelled) {
      eventsWithPromises.publish('dialog:cancelled', {
        emitter: this.context
      });
    }
  };

  DialogProto.appendTargetToDialog = function($el) {
    this.$dialogContentInner.append($el);

    eventsWithPromises.publish('dialog:ready', {
      emitter: this.context
    });
  };

  return Dialog;
});
