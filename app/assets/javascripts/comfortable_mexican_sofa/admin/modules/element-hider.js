define('element-hider', [], function () {
  'use strict';

  function ElementHider(options) {
    this.options = options;
    this.activeClass = this.options.activeClass || 'is-active';
    this.transitionEnd = 'transitionend' || 'webkitTransitionEnd' || 'MSTransitionEnd' || 'oTransitionEnd';
    this.elements = {
      mainNode: this.options.mainNode,
      closeNode: this.options.closeNode
    };
    this.hide = this.hide.bind(this);
    this.remove = this.remove.bind(this);
  }

  ElementHider.prototype.init = function() {
    this.setupEventListeners();

    if(this.options.delay) {
      setTimeout(function() {
        this.hide();
      }.bind(this), this.options.delay);
    }
  };

  ElementHider.prototype.setupEventListeners = function() {
    this.elements.closeNode.addEventListener('click', this.hide);
    this.elements.mainNode.addEventListener(this.transitionEnd, this.remove);
  };

  ElementHider.prototype.hide = function() {
    this.elements.mainNode.classList.remove(this.activeClass);
  };

  ElementHider.prototype.remove = function() {
    var node = this.elements.mainNode;
    this.elements.mainNode.parentNode.removeChild(node);
  };

  return ElementHider;
});
