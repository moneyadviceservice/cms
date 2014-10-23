define(['jquery', 'DoughBaseComponent', 'Collapsable'], function($, DoughBaseComponent, Collapsable) {

  'use strict';

  var PopoverCollapsable,
      defaultConfig = {
        direction: 'top'
      };

  PopoverCollapsable = function($el, config) {
    PopoverCollapsable.baseConstructor.call(this, $el, config, defaultConfig);
    this.$trigger.find('[data-dough-collapsable-icon]').remove();
  };

  /**
   * Inherit from base module, for shared methods and interface
   */
  DoughBaseComponent.extend(PopoverCollapsable, Collapsable);

  PopoverCollapsable.prototype.toggle = function() {
    PopoverCollapsable.superclass.toggle.call(this);
    this.setOffset();
  };

  PopoverCollapsable.prototype.setOffset = function() {
    this.$target.css(this.calculateOffset(this.$el, this.config.direction));
  };

  PopoverCollapsable.prototype.calculateOffset = function($from, direction) {
    var dispatch;

    dispatch = {
      top: function() {
        return {
          left: '420px',
          position: 'absolute',
          top: '40px'
        };
      },

      left: function() {
        return {
          left: '5px',
          position: 'absolute',
          top: '140px'
        };
      }
    };
    return (dispatch[direction] || dispatch.left)();
  };

  PopoverCollapsable.prototype.getElementCenter = function($el) {
    return {
      horizontal: $el.width() / 2,
      vertical: $el.height() / 2
    };
  };

  return PopoverCollapsable;
});
