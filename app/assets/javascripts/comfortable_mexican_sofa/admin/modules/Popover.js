define(['jquery', 'DoughBaseComponent', 'Collapsable'], function($, DoughBaseComponent, Collapsable) {

  'use strict';

  var Popover,
      defaultConfig = {
        direction: 'top',
        centerAlign: false,
        selectors: {
          pointer: '[data-dough-collapsable-pointer]'
        }
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
    this.direction = this.config.direction === 'left' || this.config.direction === 'right'? 'horizontal' : 'vertical';
    this.cacheComponentElements();

    $(window).on('resize', function() {
      clearTimeout(resize);
      resize = setTimeout(_this.handleResize, 100);
    });
  };

  Popover.prototype.cacheComponentElements = function() {
    this.$pointer = this.$target.find('[data-dough-collapsable-pointer]');
  };

  Popover.prototype.handleResize = function() {
    this.setPositions();
  };

  Popover.prototype.toggle = function() {
    Popover.superclass.toggle.call(this);
    this.isShown? this.detachTarget() : this.attachTarget();
    this.setPositions();
  };

  Popover.prototype.detachTarget = function() {
    this.$locationMarker = $('<span />').insertBefore(this.$target);
    this.$target.detach();
    this.$target.appendTo('body');
  };

  Popover.prototype.attachTarget = function() {
    this.$target.insertBefore(this.$locationMarker);
    this.$locationMarker.remove();
  };

  Popover.prototype.setPositions = function() {
    this.bodyOffset = this.getBodyOffset();
    this.$target.css(this.calculateTargetOffsetFromTrigger(this.config.direction));
    if(this.$pointer) {
      this.$pointer.css(this.calculatePointerOffsetFromTrigger(this.direction));
    }
  };

  Popover.prototype.centerAlignTargetToTrigger = function(pos, direction) {
    return pos - this.getElementCenterPosition(this.$target)[direction] + this.getElementCenterPosition(this.$trigger)[direction];
  };

  Popover.prototype.calculateTargetOffsetFromTrigger = function(direction) {
    var directions;

    function calculateLeft() {
      var left = this.getElementBoundaries(this.$trigger).left + this.bodyOffset.left;

      if(this.config.centerAlign) {
        left = this.centerAlignTargetToTrigger(left, 'horizontal');
      }
      if(left < 0) {
        left = 0;
      }
      return left;
    }

    function calculateTop() {
      var top = this.getElementBoundaries(this.$trigger).top + this.bodyOffset.top;

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
        right: $('body').width() - this.getElementBoundaries(this.$trigger).left + this.bodyOffset.left,
        top: calculateTop.call(this)
      },

      right: {
        left: this.getElementBoundaries(this.$trigger).left + this.$trigger.outerWidth() + this.bodyOffset.left,
        top: calculateTop.call(this)
      }
    };
    return directions[direction] || directions.right;
  };

  Popover.prototype.calculatePointerOffsetFromTrigger = function(direction) {
    var directions = {
      horizontal: {
        top: this.getElementBoundaries(this.$trigger).top + this.getElementCenterPosition(this.$trigger).vertical - this.getElementBoundaries(this.$target).top
      },
      vertical: {
        left: this.getElementBoundaries(this.$trigger).left + this.getElementCenterPosition(this.$trigger).horizontal - this.getElementBoundaries(this.$target).left
      }
    };
    return directions[direction] || directions.horizontal;
  };

  Popover.prototype.getElementBoundaries = function($el) {
    return {
      top: Math.floor($el.offset().top - this.bodyOffset.top),
      bottom: Math.floor($el.offset().top + $el.outerHeight()),
      left: Math.floor($el.offset().left - this.bodyOffset.left),
      right: Math.floor($el.offset().left + $el.outerWidth())
    };
  };

  Popover.prototype.getBodyOffset = function() {
    var $offsetHook = $('<div />').css({'height': '1px','width':'1px'}).prependTo('body'),
        offset = $offsetHook.position();
    $offsetHook.remove();
    return offset;
  };

  Popover.prototype.getElementCenterPosition = function($el) {
    return {
      horizontal: Math.floor($el.outerWidth() / 2),
      vertical: Math.floor($el.outerHeight() / 2)
    };
  };

  return Popover;
});
