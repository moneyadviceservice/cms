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
          content: '[data-dough-dialog-content]',
          close: '[data-dough-dialog-close]',
          activeClass: 'is-active',
          inactiveClass: 'is-inactive'
        }
      };

  function Dialog($el, config) {
    Dialog.baseConstructor.call(this, $el, config, defaultConfig);
    this.isShown = false;
  }

  DoughBaseComponent.extend(Dialog);

  DialogProto = Dialog.prototype;

  DialogProto.init = function(initialised) {
    this._cacheComponentElements();
    this._setupDialog();
    this._setupUIEvents();
    this._initialisedSuccess(initialised);
  };

  DialogProto._cacheComponentElements = function() {
    this.$trigger = this.$el;
    this.$target = $('[data-dough-dialog-target="' + this.$trigger.attr('data-dough-dialog-trigger') + '"]');
  };

  DialogProto._setupDialog = function() {
    this.$dialog = $('<dialog data-dough-dialog class="dialog is-inactive" />');
    this.$dialogContainer = $('<div data-dough-dialog-container class="dialog__container" />');
    this.$dialogContent = $('<div data-dough-dialog-content class="dialog__content" />');
    this.$dialogClose = $('<button data-dough-dialog-close class="dialog__close"><span class="dialog__close-text visually-hidden">Close</span></button>');
    this.$dialog
      .appendTo('body')
      .append(this.$dialogContainer.add(this.$dialogContent).add(this.$dialogClose));
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

  DialogProto._handleCancel = function() {
    this.close(true);
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

    this.$dialog.addClass(this.config.selectors.activeClass);
    this.$target
      .removeClass(this.config.selectors.inactiveClass)
      .addClass(this.config.selectors.activeClass);
    this.isShown = true;

    eventsWithPromises.publish('dialog:shown', {
      emitter: this.$target,
      modal: showModal
    });
  };

  DialogProto.close = function(cancelled) {
    if(!this.isShown) return;

    if(!cancelled) {
      this.dialog.close();
    }

    this._attachTarget();
    this.$dialog.removeClass(this.config.selectors.activeClass);
    this.$target
      .removeClass(this.config.selectors.activeClass)
      .addClass(this.config.selectors.inactiveClass);
    this.isShown = false;

    eventsWithPromises.publish('dialog:closed', {
      emitter: this.$target
    });

    if(cancelled) {
      eventsWithPromises.publish('dialog:cancelled', {
        emitter: this.$target
      });
    }
  };

  DialogProto.appendTargetToDialog = function($el) {
    this.$dialogContent.append($el);

    eventsWithPromises.publish('dialog:ready', {
      emitter: this.$target
    });
  };

  return Dialog;
});
