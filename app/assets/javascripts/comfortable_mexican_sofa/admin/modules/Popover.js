define(['jquery', 'DoughBaseComponent', 'Collapsable'], function($, DoughBaseComponent, Collapsable) {

  'use strict';

  var Popover,
      defaultConfig = {
        direction: 'top',
        centerAlign: false
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
    this.$target.css(this.calculateOffsetFromTrigger(this.config.direction));
  };

  Popover.prototype.centerAlignTargetToTrigger = function(pos, direction) {
    return pos - this.getElementCenterPosition(this.$target)[direction] + this.getElementCenterPosition(this.$trigger)[direction];
  };

  Popover.prototype.calculateOffsetFromTrigger = function(direction) {
    var directions;
    
    function calculateLeft() {
      var left = this.getElementBoundaries(this.$trigger).left;

      if(this.config.centerAlign) {
        left = this.centerAlignTargetToTrigger(left, 'horizontal');
      }
      if(left < 0) {
        left = 0;
      }
      return left;
    }

    function calculateTop() {
      var top = this.getElementBoundaries(this.$trigger).top;

      if(this.config.centerAlign) {
        top = this.centerAlignTargetToTrigger(top, 'vertical');
      }
      return top;
    }

    directions = {
      top:  {
        left: calculateLeft.call(this),
        top: this.getElementBoundaries(this.$trigger).bottom - this.$trigger.outerHeight() - this.$target.outerHeight()
      },

      bottom: {
        left: calculateLeft.call(this),
        top: this.getElementBoundaries(this.$trigger).bottom
      },

      left: {
        right: $('body').width() - this.getElementBoundaries(this.$trigger).left,
        top: calculateTop.call(this)
      },

      right: {
        left: this.getElementBoundaries(this.$trigger).left + this.$trigger.outerWidth(),
        top: calculateTop.call(this)
      }
    };
    return directions[direction] || directions.right;
  };

  Popover.prototype.getElementBoundaries = function($el) {
    return {
      top: Math.floor($el.position().top),
      bottom: Math.floor($el.position().top + $el.outerHeight()),
      left: Math.floor($el.position().left),
      right: Math.floor($el.position().left + $el.outerWidth())
    };
  };

  Popover.prototype.getElementCenterPosition = function($el) {
    return {
      horizontal: Math.floor($el.outerWidth() / 2),
      vertical: Math.floor($el.outerHeight() / 2)
    };
  };

  return Popover;
});
