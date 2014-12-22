describe('Mirror Input Value', function() {
  'use strict';

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'jquery',
      'MirrorInputValue',
      'phantom-shims'
    ],
    function(
      $,
      MirrorInputValue
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/MirrorInputValue.html']);
      self.MirrorInputValue = MirrorInputValue;
      self.dummyValue = 'foo';
      $('body').append(self.$html);
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
  });

  describe('General', function() {
    beforeEach(function(done) {
      this.targetKeyupSpy = sinon.spy(this.MirrorInputValue.prototype, '_handleTargetKeyup');
      this.component = new this.MirrorInputValue(this.$html);
      this.component.init();
      done();
    });

    afterEach(function() {
      this.targetKeyupSpy.restore();
    });

    it('should update the targets\'s value with the trigger\'s value on keyup event', function() {
      this.component.$triggerInput.val(this.dummyValue);
      this.component.$triggerInput.trigger('keyup');
      expect(this.component.$targetInput.val()).to.equal(this.dummyValue);
    });

    it('should unbind the trigger\'s and target\'s keyup events when the target has been edited directly', function() {
      this.component.$targetInput.val(this.dummyValue);
      this.component.$targetInput.trigger('keyup');
      this.component.$targetInput.trigger('keyup');
      expect(this.targetKeyupSpy.callCount).to.equal(1);
    });
  });

});
