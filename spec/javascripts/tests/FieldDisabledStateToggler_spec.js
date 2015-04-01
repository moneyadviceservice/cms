describe('FieldDisabledStateToggler', function() {
  'use strict';

  var sandbox;

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'phantom-shims',
      'jquery',
      'FieldDisabledStateToggler'
    ],
    function(
      phantomShims,
      $,
      FieldDisabledStateToggler
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/FieldDisabledStateToggler.html']).appendTo('body');
      self.$fixture = self.$html.find('[data-dough-component="FieldDisabledStateToggler"]');
      self.FieldDisabledStateToggler = FieldDisabledStateToggler;
      sandbox = sinon.sandbox.create();
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
    sandbox.restore();
  });

  describe('double clicking a disabled field', function() {
    beforeEach(function(done) {
      this.component = new this.FieldDisabledStateToggler(this.$fixture);
      done();
    });

    it('should enable the field', function() {
      this.component.init();
      this.component.$el.attr(this.component.disabledAttr, true);
      this.component.$hotspot.trigger('dblclick');
      expect(!!this.component.$el.attr(this.component.disabledAttr)).to.be.false;
    });
  });

  describe('moving to a different field', function() {
    beforeEach(function(done) {
      this.component = new this.FieldDisabledStateToggler(this.$fixture);
      done();
    });

    it('should disable the field', function() {
      this.component.init();
      this.component.$el.trigger('blur');
      expect(this.component.$el).to.have.attr(this.component.disabledAttr);
    });
  });

  describe('hitting the ESC key when focussed on the field', function() {
    beforeEach(function(done) {
      this.component = new this.FieldDisabledStateToggler(this.$fixture);
      done();
    });

    it('should disable the field', function() {
      var e = jQuery.Event('keyup');
      e.keyCode = 27;

      this.component.init();
      this.component.$el.focus();
      $(document).trigger(e);

      expect(this.component.$el).to.have.attr(this.component.disabledAttr);
    });
  });
});
