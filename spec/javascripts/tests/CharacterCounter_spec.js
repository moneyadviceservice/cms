describe('CharacterCounter', function() {
  'use strict';

  var sandbox;

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'phantom-shims',
      'jquery',
      'CharacterCounter'
    ],
    function(
      phantomShims,
      $,
      CharacterCounter
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/CharacterCounter.html']).appendTo('body');
      self.$fixture = self.$html.find('[data-dough-component="CharacterCounter"]');
      self.CharacterCounter = CharacterCounter;
      sandbox = sinon.sandbox.create();
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
    sandbox.restore();
  });

  describe('On initialisation', function() {
    beforeEach(function(done) {
      this.component = new this.CharacterCounter(this.$fixture);
      done();
    });

    it('should find and cache at least one indicator element', function() {
      this.component.init();
      expect(this.component.$indicators.length).to.be.at.least(1);
    });

    it('should update the character indicator with the number of inputted characters', function() {
      var str = 'foo';
      this.component.$el.val(str);
      this.component.init();
      expect(parseInt(this.component.$indicators.eq(0).text(),10)).to.eq(this.component.maxChars - str.length);
    });
  });

  describe('#getCharacterLength', function () {
    beforeEach(function(done) {
      this.component = new this.CharacterCounter(this.$fixture);
      this.component.init();
      done();
    });

    it('should get the string length of the input', function() {
      var str = 'foo';
      this.component.$el.val(str);
      expect(this.component.getInputCharacterLength()).to.equal(str.length);
    });
  });

  describe('#calculateCharacterCount', function () {
    beforeEach(function(done) {
      this.component = new this.CharacterCounter(this.$fixture);
      this.component.init();
      done();
    });

    it('should calculate the difference between maxChars and the count', function() {
      var count = 100,
          maxChars = 50;

      expect(this.component.calculateCharacterCount(count, maxChars)).to.equal(maxChars - count);
    });
  });

  describe('#updateUI', function () {
    beforeEach(function(done) {
      this.component = new this.CharacterCounter(this.$fixture);
      this.component.init();
      done();
    });

    it('should add the aboveMaxClass if the count is above max number of characters', function() {
      this.component.updateUI(120, 100);
      expect(this.component.$indicators.add(this.component.$warnings)).to.have.class(this.component.config.selectors.aboveMaxClass);
    });

    it('should add the belowMaxClass if the count is below max number of characters', function() {
      this.component.updateUI(100, 120);
      expect(this.component.$indicators.add(this.component.$warnings)).to.have.class(this.component.config.selectors.belowMaxClass);
    });

    it('should add the zeroClass if the count is equal to 0', function() {
      this.component.updateUI(100, 100);
      expect(this.component.$indicators.add(this.component.$warnings)).to.have.class(this.component.config.selectors.zeroClass);
    });

    it('should update the indicator text with the character count', function() {
      this.component.updateUI(100, 100);
      expect(this.component.$indicators.eq(0).text()).to.equal('0');
    });
  });

  describe('#_handleInput', function () {
    beforeEach(function(done) {
      this.component = new this.CharacterCounter(this.$fixture);
      done();
    });

    it('should call the #updateUI() function when input is given', function() {
      var spy = sandbox.spy(this.CharacterCounter.prototype, 'updateUI'),
          val = 'foo';

      this.component.init();
      this.component.$el.val(val).trigger('input');
      expect(spy.calledWith(val.length, this.component.maxChars)).to.be.true;
    });

    it('should set the count property', function() {
      this.component.count = 0;
      this.component.init();
      this.component.$el.val('foo').trigger('input');
      expect(this.component.count).to.not.equal(0);
    });
  });
});
