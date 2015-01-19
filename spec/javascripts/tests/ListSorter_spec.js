describe('ListSorter', function() {
  'use strict';

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'jquery',
      'ListSorter'
    ],
    function(
      $,
      ListSorter
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/ListSorter.html']).appendTo('body');
      self.$fixture = $('body').find('[data-dough-component="ListSorter"]');
      self.ListSorter = ListSorter;
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
  });

  describe('#init', function() {
    beforeEach(function(done) {
      this.component = new this.ListSorter(this.$fixture);
      this.component.init();
      done();
    });

    it('it should find and cache the related order fields', function() {
      expect(this.component.$listOrderFields.length).to.be.at.least(1);
    });
  });

  describe('#setOrderFieldValue', function () {
    beforeEach(function(done) {
      this.component = new this.ListSorter(this.$fixture);
      this.component.init();
      done();
    });

    it('should set the order field to the passed value', function() {
      var order = '[436,34,26,78]';
      this.component.setOrderFieldValue(order);
      expect(this.component.$listOrderFields.val()).to.equal(order);
    });
  });

  describe('#getListOrderArray', function () {
    beforeEach(function(done) {
      this.component = new this.ListSorter(this.$fixture);
      this.component.init();
      done();
    });

    it('should iterate over the list items and return an ordered array of IDs', function() {
      expect(this.component.getListOrderArray()).to.eql(['92','44','127']);
    });
  });
});
