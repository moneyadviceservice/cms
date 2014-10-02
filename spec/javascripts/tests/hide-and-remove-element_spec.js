describe('Hide and Remove element', function () {
  'use strict';

  beforeEach(function(done) {
    var self = this;

    require.config({
      context : 'ctx' + new Date().getTime()
    });

    requirejs([
      'hide-and-remove-element',
      'phantom-shims'
    ],
    function (
      hideAndRemoveElement
    ) {
      self.sandbox = document.createElement('div');
      self.sandbox.innerHTML = window.__html__['spec/javascripts/fixtures/hide-and-remove-element.html'];
      document.body.appendChild(self.sandbox);
      self.classActive = 'is-active';
      self.classMainNode = '.js-alert';
      self.delay = 1000;
      self.hideAndRemoveElement = hideAndRemoveElement;
      self.hideSpy = sinon.spy(self.hideAndRemoveElement, 'hide');
      self.hideAndRemoveElement.init({
        mainNode: document.querySelector(self.classMainNode),
        closeNode: document.querySelector('.js-close-alert'),
        delay: self.delay
      });
      done();
    }, done);
  });

  afterEach(function() {
    this.sandbox.parentNode.removeChild(this.sandbox);
  });

  describe('Clicking the alert', function () {
    it('should hide it and remove it from the DOM', function() {
      var evt = document.createEvent('HTMLEvents'),
          mainNode = this.hideAndRemoveElement.elements.mainNode,
          closeNode = this.hideAndRemoveElement.elements.closeNode;

      evt.initEvent('transitionend', false);

      closeNode.click();
      expect(this.hideSpy).to.have.been.called;
      expect(mainNode.classList.contains(this.hideAndRemoveElement.activeClass)).to.be.false;
      mainNode.dispatchEvent(evt);
      expect(document.body.querySelector(this.classMainNode)).to.be.null;
    });
  });

  describe('After a delay', function () {
    beforeEach(function (done) {
      var evt = document.createEvent('HTMLEvents');
      evt.initEvent('transitionend', false);

      setTimeout(function() {
        this.hideAndRemoveElement.elements.mainNode.addEventListener('transitionend', function() {});
        this.hideAndRemoveElement.elements.mainNode.dispatchEvent(evt);
        done();
      }.bind(this), this.delay);
    });

    it('should hide it and remove it from the DOM', function() {
      var mainNode = this.hideAndRemoveElement.elements.mainNode;
      expect(this.hideSpy).to.have.been.called;
      expect(mainNode.classList.contains(this.hideAndRemoveElement.activeClass)).to.be.false;
      expect(document.body.querySelector(this.classMainNode)).to.be.null;
    });
  });
});
