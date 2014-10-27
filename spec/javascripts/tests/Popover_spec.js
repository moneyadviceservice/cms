describe('Popover', function () {
  'use strict';

  beforeEach(function(done) {
    var self = this;
    requirejs([
      'jquery',
      'Popover'
    ],
    function (
      $,
      Popover
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/Popover.html']).appendTo('body');
      self.$fixture = self.$html.find('[data-dough-component="Popover"]');
      self.$fixture.css({width:'200px'});
      self.Popover = Popover;
      $('body').height(1000).width(1000).css({position:'relative'});
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
  });

  describe('General', function () {
    describe('Position left', function () {
      beforeEach(function (done) {
        this.component = new this.Popover(this.$fixture, {
          direction: 'left'
        });
        this.component.init();
        done();
      });

      it('should position itself to the left of the trigger', function() {
        var $target = this.component.$target,
            $trigger = this.component.$trigger;

        $trigger.click();
        expect(this.component.getElementBoundaries($target).right).to.be.below($('body').width());
      });
    });

    describe('Position right', function () {
      beforeEach(function (done) {
        this.component = new this.Popover(this.$fixture, {
          direction: 'right'
        });
        this.component.init();
        done();
      });

      it('should position itself to the right of the trigger', function() {
        var $trigger = this.component.$trigger,
            $target = this.component.$target;

        $trigger.click();
        expect($target.position().left).to.be.equal(this.component.getElementBoundaries($trigger).right);
      });
    });


    describe('Position Top', function () {
      beforeEach(function (done) {
        this.component = new this.Popover(this.$fixture, {
          direction: 'top'
        });
        this.component.init();
        done();
      });

      it('should position itself above the trigger', function() {
        var $target = this.component.$target,
            $trigger = this.component.$trigger;

        $trigger.click();
        expect(this.component.getElementBoundaries($target).bottom).to.be.equal(Math.round($trigger.position().top));
      });
    });

    describe('Position Bottom', function () {
      beforeEach(function (done) {
        this.component = new this.Popover(this.$fixture, {
          direction: 'bottom'
        });
        this.component.init();
        done();
      });

      it('should position itself below the trigger', function() {
        var $target = this.component.$target,
            $trigger = this.component.$trigger;

        $trigger.click();
        expect($target.position().top).to.be.above($trigger.position().top);
        expect(this.component.getElementBoundaries($target).bottom).to.be.below($('body').height());
      });
    });
  });
});
