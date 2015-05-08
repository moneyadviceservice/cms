describe('Popover', function() {
  'use strict';

  beforeEach(function(done) {
    var self = this;
    requirejs([
      'jquery',
      'Popover'
    ],
    function(
      $,
      Popover
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/Popover.html']).appendTo('body');
      self.$fixture = $('body').find('[data-dough-component="Popover"]');
      self.$trigger = self.$html.filter('[data-dough-collapsable-trigger]');
      self.$trigger.css({
        background: 'blue',
        height: '100px',
        width: '200px'
      });
      self.$target = self.$html.filter('[data-dough-collapsable-target]');
      self.$target.css({
        background: 'red',
        height: '100px',
        width: '200px'
      });
      self.Popover = Popover;
      $('body').css({height: '1000px', width: '1000px', margin: 0, padding: 0});
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
  });

  function getElementCenterFromViewport(component, $el, direction) {
    return Math.floor(component.getElementBoundaries($el)[direction === 'horizontal'? 'left' : 'top'] + component.getElementCenterPosition($el)[direction]);
  }

  describe('Close target on click', function() {
    beforeEach(function(done) {
      this.component = new this.Popover(this.$fixture, {
        direction: 'top',
        closeOnClick: true
      });
      this.component.init();
      done();
    });
    it('should close when a click/touchend event is detected inside the target container', function() {
      this.component.$triggers.click();
      expect(this.component.isShown).to.be.true;
      this.component.$target.click();
      expect(this.component.isShown).to.be.false;
    });
  });

  describe('Position left', function() {
    describe('Default', function() {
      beforeEach(function(done) {
        this.component = new this.Popover(this.$fixture, {
          direction: 'left'
        });
        this.component.init();
        done();
      });

      it('should position itself to the left of the trigger', function() {
        var $target = this.component.$target,
            $trigger = this.component.$triggers;

        $trigger.click();
        expect(this.component.getElementBoundaries($target).right).to.be.below($('body').width());
      });
    });

    describe('With vertical alignment enabled', function() {
      beforeEach(function(done) {
        this.$fixture.css({
          margin: 'auto'
        });
        this.component = new this.Popover(this.$fixture, {
          direction: 'left',
          centerAlign: true
        });
        this.component.init();
        done();
      });

      it('should vertically centre itself to the trigger', function() {
        var $target = this.component.$target,
            $trigger = this.component.$triggers;

        $trigger.click();
        expect(getElementCenterFromViewport(this.component, $trigger, 'vertical'))
          .to.equal(getElementCenterFromViewport(this.component, $target, 'vertical'));
      });
    });
  });

  describe('Position right', function() {
    describe('Default', function() {
      beforeEach(function(done) {
        this.component = new this.Popover(this.$fixture, {
          direction: 'right'
        });
        this.component.init();
        done();
      });

      it('should position itself to the right of the trigger', function() {
        var $trigger = this.component.$triggers,
            $target = this.component.$target;

        $trigger.click();
        expect(this.component.getElementBoundaries($target).left)
          .to.be.equal(this.component.getElementBoundaries($trigger).right);
      });
    });

    describe('With vertical alignment enabled', function() {
      beforeEach(function(done) {
        this.component = new this.Popover(this.$fixture, {
          direction: 'right',
          centerAlign: true
        });
        this.component.init();
        done();
      });

      it('should vertically centre itself to the trigger', function() {
        var $target = this.component.$target,
            $trigger = this.component.$triggers;

        $trigger.click();
        expect(getElementCenterFromViewport(this.component, $trigger, 'vertical'))
          .to.equal(getElementCenterFromViewport(this.component, $target, 'vertical'));
      });
    });
  });

  describe('Position Top', function() {
    describe('Default', function() {
      beforeEach(function(done) {
        this.component = new this.Popover(this.$fixture, {
          direction: 'top'
        });
        this.component.init();
        done();
      });

      it('should position itself above the trigger', function() {
        var $target = this.component.$target,
            $trigger = this.component.$triggers;

        $trigger.click();
        expect(this.component.getElementBoundaries($target).bottom)
          .to.be.equal(this.component.getElementBoundaries($target).bottom);
      });
    });

    describe('With horizontal alignment enabled', function() {
      beforeEach(function(done) {
        this.component = new this.Popover(this.$fixture, {
          direction: 'top',
          centerAlign: true
        });
        this.component.init();
        done();
      });

      it('should horizontally centre itself to the trigger', function() {
        var $target = this.component.$target,
            $trigger = this.component.$triggers;

        this.$trigger.css({
          margin: '100px auto 0'
        });

        $trigger.click();
        expect(getElementCenterFromViewport(this.component, $trigger, 'horizontal'))
          .to.equal(getElementCenterFromViewport(this.component, $target, 'horizontal'));
      });
    });
  });

  describe('Position Bottom', function() {
    describe('Default', function() {
      beforeEach(function(done) {
        this.component = new this.Popover(this.$fixture, {
          direction: 'bottom'
        });
        this.component.init();
        done();
      });

      it('should position itself below the trigger', function() {
        var $target = this.component.$target,
            $trigger = this.component.$triggers;

        $trigger.css({
          display : 'block'
        });
        $trigger.click();
        expect($target.offset().top).to.be.above($trigger.offset().top);
        expect(this.component.getElementBoundaries($target).bottom).to.be.below($('body').height());
      });
    });

    describe('With horizontal alignment enabled', function() {
      beforeEach(function(done) {
        this.component = new this.Popover(this.$fixture, {
          direction: 'bottom',
          centerAlign: true
        });
        this.component.init();
        done();
      });

      it('should horizontally centre itself to the trigger', function() {
        var $target = this.component.$target,
            $trigger = this.component.$triggers;

        this.component.$el.css({
          margin: '0 auto'
        });

        $trigger.click();
        expect(getElementCenterFromViewport(this.component, $trigger, 'horizontal'))
          .to.equal(getElementCenterFromViewport(this.component, $target, 'horizontal'));
      });
    });
  });

});
