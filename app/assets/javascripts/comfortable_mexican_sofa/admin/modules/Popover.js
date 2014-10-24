define(['jquery', 'DoughBaseComponent', 'Collapsable'], function($, DoughBaseComponent, Collapsable) {

  'use strict';

  var Popover,
      defaultConfig = {
        direction: 'top'
      };

  Popover = function($el, config) {
    Popover.baseConstructor.call(this, $el, config, defaultConfig);
    this.$trigger.find('[data-dough-collapsable-icon]').remove();
  };

  /**
   * Inherit from base module, for shared methods and interface
   */
  DoughBaseComponent.extend(Popover, Collapsable);

  Popover.prototype.init = function() {
    Popover.superclass.init.call(this);

    var resize,
        _this = this;

    this.handleResize = $.proxy(this.handleResize, this);
    this.$target.css({
      position: 'absolute'
    });
    console.log(this.getElementBoundaries(this.$trigger));

    $(window).on('resize', function() {
      clearTimeout(resize);
      resize = setTimeout(_this.handleResize, 100);
    });
  };

  Popover.prototype.handleResize = function() {
    this.updatePosition();
  };

  Popover.prototype.toggle = function() {
    Popover.superclass.toggle.call(this);
    this.updatePosition();
  };

  Popover.prototype.updatePosition = function() {
    this.setOffset();
  };

  Popover.prototype.setOffset = function() {
    this.$target.css(this.calculateOffsetFromAnchor(this.$trigger, this.$target, this.config.direction));
  };

  Popover.prototype.calculateOffsetFromAnchor = function($anchor, $target, direction) {
    var dispatch;

    dispatch = {
      top: function() {
        return {
          left: this.unitise(this.getElementBoundaries($anchor).left,'px'),
          top: this.unitise(this.getElementBoundaries($anchor).bottom - $anchor.outerHeight() - $target.outerHeight(),'px')
        };
      },

      bottom: function() {
        return {
          left: this.unitise(this.getElementBoundaries($anchor).left,'px'),
          top: this.unitise(this.getElementBoundaries($anchor).bottom,'px')
        };
      },

      left: function() {
        return {
          right: this.unitise($('body').width() - this.getElementBoundaries($anchor).left,'px'),
          top: this.unitise(this.getElementBoundaries($anchor).top,'px')
        };
      },

      right: function() {
        return {
          left: this.unitise(this.getElementBoundaries($anchor).left + $anchor.outerWidth(),'px'),
          top: this.unitise(this.getElementBoundaries($anchor).top,'px')
        };
      }
    };
    return $.proxy((dispatch[direction] || dispatch.right), this)();
  };

  Popover.prototype.getElementBoundaries = function($el) {
    return {
      top: $el.position().top,
      bottom: $el.position().top + $el.outerHeight(),
      left: $el.position().left,
      right: $el.position().left + $el.outerWidth()
    };
  };

  Popover.prototype.getElementCenterPosition = function($el) {
    return {
      horizontal: $el.outerWidth() / 2,
      vertical: $el.outerHeight() / 2
    };
  };

  Popover.prototype.unitise = function(val, unit) {
    return Math.round(val) + unit;
  };

  return Popover;
});
