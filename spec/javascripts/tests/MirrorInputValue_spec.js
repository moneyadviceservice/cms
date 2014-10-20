describe('Mirror Input Value', function () {
  'use strict';

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'jquery',
      'MirrorInputValue',
      'phantom-shims'
    ],
    function (
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

  describe('General', function () {
    beforeEach(function (done) {
      this.component = new this.MirrorInputValue(this.$html);
      this.component.init();
      done();
    });
    it('should update the targets\'s value with the trigger\s value on keyup event', function() {
      this.component.$triggerInput.val(this.dummyValue);
      this.component.$triggerInput.trigger('keyup');
      expect(this.component.$targetInput.val()).to.equal(this.dummyValue);
    });

    it('should unbind the trigger\'s and target\'s keyup events when it has been edited directly', function() {
      var spy = sinon.spy(this.component, '_handleTargetKeyup');
      // console.log(this.component._handleTargetKeyup());
      this.component.$targetInput.val('poo');
      this.component.$targetInput.trigger('keyup');
      console.log(spy);
      expect(spy.called).to.equal.false;
    });
  });

});
