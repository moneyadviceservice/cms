describe('URLFormatter', function() {
  'use strict';

  var sandbox;

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'phantom-shims',
      'jquery',
      'URLFormatter'
    ],
    function(
      phantomShims,
      $,
      URLFormatter
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/URLFormatter.html']).appendTo('body');
      self.$fixture = self.$html.find('[data-dough-component="URLFormatter"]');
      self.URLFormatter = URLFormatter;
      sandbox = sinon.sandbox.create();
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
    sandbox.restore();
  });

  describe('initialisation', function() {
    beforeEach(function(done) {
      this.component = new this.URLFormatter(this.$fixture);
      done();
    });

    it('should cache and find all the necessary DOM elements', function() {
      this.component.init();

      expect(this.component.$slugInput.length).to.be.at.least(1);
      expect(this.component.$titleInput.length).to.be.at.least(1);
      expect(this.component.$urlDisplays.length).to.be.at.least(1);
    });
  });

  describe('entering a slug value directly', function () {
    beforeEach(function(done) {
      this.component = new this.URLFormatter(this.$fixture);
      done();
    });

    it('should slugify the inputted value', function() {
      this.component.init();

      this.component.$slugInput.val('foo%^@£$%!   123-123').trigger('input');

      expect(this.component.$slugInput).to.have.value('foo-123-123');
    });

    it('should update the URL display with the built URL', function() {
      this.component.init();

      this.component.$pageType.val('foo').trigger('change');
      this.component.$slugInput.val('foo%^@£$%!   123-123').trigger('input');

      expect(this.component.$urlDisplays.eq(0)).to.have.text('foo/foo-123-123');
    });

    it('should stop any further input entries overriding the slug value', function() {
      this.component.init();

      this.component.$titleInput.val('foo').trigger('input');
      this.component.$slugInput.val('bar').trigger('input');
      this.component.$titleInput.val('baz').trigger('input');

      expect(this.component.$slugInput).to.have.value('bar');
    });
  });

  describe('entering an input value', function () {
    beforeEach(function(done) {
      this.component = new this.URLFormatter(this.$fixture);
      done();
    });

    it('should slugify the inputted value and update the slug input box', function() {
      this.component.init();

      this.component.$titleInput.val('foo%^@£$%!   123-123').trigger('input');

      expect(this.component.$slugInput).to.have.value('foo-123-123');
    });

    it('should update the URL display with the built URL', function() {
      this.component.init();

      this.component.$pageType.val('foo').trigger('change');
      this.component.$slugInput.val('foo%^@£$%!   123-123').trigger('input');

      expect(this.component.$urlDisplays.eq(0)).to.have.text('foo/foo-123-123');
    });
  });

  describe('updating the page type value', function() {
    beforeEach(function(done) {
      this.component = new this.URLFormatter(this.$fixture);
      done();
    });

    it('should update the display with the built URL', function() {
      this.component.init();

      this.component.$pageType.val('foo').trigger('change');
      this.component.$slugInput.val('bar').trigger('input');

      expect(this.component.$urlDisplays.eq(0)).to.have.text('foo/bar');
    });
  });
});
