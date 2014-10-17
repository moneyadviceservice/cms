describe('Hide and Remove element', function () {
  'use strict';

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'jquery',
      'ElementHider',
      'phantom-shims'
    ],
    function (
      $,
      ElementHider
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/ElementHider.html']);
      self.ElementHider = ElementHider;
      self.delay = 100;
      $('body').append(self.$html);
      done();
    }, done);
  });

  describe('Clicking the close node', function () {
    beforeEach(function (done) {
      this.elementHider = new this.ElementHider(this.$html);
      this.elementHider.init();
      done();
    });
    it('should hide and remove the element from the DOM', function() {
      this.elementHider.$closeBtn.click();
      expect(this.elementHider.$el.hasClass(this.elementHider.config.selectors.activeClass)).to.be.false;
    });
  });

  describe('After a delay', function () {
    beforeEach(function (done) {
      this.elementHider = new this.ElementHider(this.$html);
      this.elementHider.init();

      setTimeout(function() {
        this.elementHider.hide();
        done();
      }.bind(this), this.delay);

      done();
    });

    it('should hide the element from the DOM', function() {
      expect(this.elementHider.$el.hasClass(this.elementHider.config.selectors.activeClass)).to.be.false;
    });
  });

});
