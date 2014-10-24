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
      self.fixture = self.$html.find('[data-dough-component="Popover"]');
      self.Popover = Popover;
      $('body').height(1000);
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
  });

  function getBottomEdgePosition($el) {
    return $el.position().top + $el.height();
  }

  function getRightEdgePosition($el) {
    return $el.position().left + $el.width();
  }

  describe('General', function () {
    describe('Position left', function () {
      beforeEach(function (done) {
        this.component = new this.Popover(this.fixture, {
          direction: 'left'
        });
        this.component.init();
        done();
      });

      it('should position itself to the left of the trigger without overlapping viewport edge', function() {
        var $target = this.component.$target,
            $trigger = this.component.$trigger;

        $trigger.click();
        expect(getRightEdgePosition($target)).to.be.below(this.component.$trigger.position().left);
        expect($target.position().left).to.be.above(0);
      });
    });

    describe('Position right', function () {
      beforeEach(function (done) {
        this.component = new this.Popover(this.fixture, {
          direction: 'right'
        });
        this.component.init();
        done();
      });

      it('should position itself to the right of the trigger without overlapping viewport edge', function() {
        var $trigger = this.component.$trigger,
            $target = this.component.$target;

        $trigger.click();
        expect($target.position().left).to.be.above(getRightEdgePosition($trigger));
        expect($target.position().top).to.be.above(0);
      });
    });


    describe('Position Top', function () {
      beforeEach(function (done) {
        this.component = new this.Popover(this.fixture, {
          direction: 'top'
        });
        this.component.init();
        done();
      });

      it('should position itself above the trigger and without overlapping viewport edge', function() {
        var $target = this.component.$target,
            $trigger = this.component.$trigger;

        $trigger.click();
        expect(getBottomEdgePosition($target)).to.be.equal($trigger.position().top);
        expect($target.position().top).to.be.above(0);
      });
    });

    describe('Position Bottom', function () {
      beforeEach(function (done) {
        this.component = new this.Popover(this.fixture, {
          direction: 'bottom'
        });
        this.component.init();
        done();
      });

      it('should position itself below the trigger and without overlapping viewport edge', function() {
        var $target = this.component.$target,
            $trigger = this.component.$trigger;

        $trigger.click();
        expect($target.position().top).to.be.above($trigger.position().top);
        expect(getBottomEdgePosition($target)).to.be.below($('body').height());
      });

      it('should reposition itself when the window is resized', function() {

      });
    });
  });
});
