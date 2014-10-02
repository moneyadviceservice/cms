define('hide-and-remove-element', [], function () {
  'use strict';
  return {
    init: function(options) {
      this.options = options;
      this.activeClass = this.options.activeClass || 'is-active';
      this.transitionEnd = 'transitionend' || 'webkitTransitionEnd' || 'MSTransitionEnd' || 'oTransitionEnd';
      this.elements = {
        mainNode: this.options.mainNode,
        closeNode: this.options.closeNode
      };
      this.hide = this.hide.bind(this);
      this.remove = this.remove.bind(this);

      if(!this.elements.mainNode) return;
      if(this.options.delay) {
        setTimeout(function() {
          this.hide();
        }.bind(this), this.options.delay);
      }
      this.setupEventListeners();
    },

    setupEventListeners: function() {
      this.elements.closeNode.addEventListener('click', this.hide);
      this.elements.mainNode.addEventListener(this.transitionEnd, this.remove);
    },

    hide: function() {
      this.elements.mainNode.classList.remove(this.activeClass);
    },

    remove: function() {
      var node = this.elements.mainNode;
      this.elements.mainNode.parentNode.removeChild(node);
    }
  };
});
