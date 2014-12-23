describe('Element Filter', function () {
  'use strict';

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'jquery',
      'ElementFilter'
    ],
    function (
      $,
      ElementFilter
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/ElementFilter.html']).appendTo('body');
      self.$fixture = $('body').find('[data-dough-component="ElementFilter"]');
      self.ElementFilter = ElementFilter;
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
  });

  describe('Filtering', function () {
    beforeEach(function (done) {
      this.component = new this.ElementFilter(this.$fixture);
      this.component.init();
      done();
    });

    it('should toggle filtered items', function() {
      this.component.$trigger.click();
      expect(this.component.$filterableItems.hasClass(this.component.config.selectors.activeClass)).to.be.true;
    });

    it('should toggle new filterable items added to the list', function () {
      var $clonedElement = this.component.$filterableItems.first().clone();
      this.component.$target.append($clonedElement);
      this.component.$trigger.click();
      expect($clonedElement.hasClass(this.component.config.selectors.activeClass)).to.be.true;
    });

    it('should only affect items within its context', function() {
      var $dummyList = $('[data-dough-element-filter-target="dummy"]');
      expect($dummyList.children().hasClass(this.component.config.selectors.activeClass)).to.be.false;
      this.component.$trigger.click();
      expect($dummyList.children().hasClass(this.component.config.selectors.activeClass)).to.be.false;
    });
  });

});
