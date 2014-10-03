describe('Hide and Remove element', function () {
  'use strict';

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'element-hider',
      'phantom-shims'
    ],
    function (
      ElementHider
    ) {
      self.sandbox = document.createElement('div');
      self.sandbox.innerHTML = window.__html__['spec/javascripts/fixtures/element-hider.html'];
      document.body.appendChild(self.sandbox);
      self.classActive = 'is-active';
      self.classMainNode = '.js-element';
      self.delay = 1000;
      self.elementHider = new ElementHider({
        mainNode: document.querySelector(self.classMainNode),
        closeNode: document.querySelector('.js-close-element'),
        delay: self.delay
      });
      self.elementHider.init();
      self.hideSpy = sinon.spy(self.elementHider, 'hide');
      done();
    }, done);
  });

  afterEach(function() {
    this.sandbox.parentNode.removeChild(this.sandbox);
  });

  describe('Clicking the close node', function () {
    it('should hide and remove the element from the DOM', function() {
      var evt = document.createEvent('HTMLEvents'),
          mainNode = this.elementHider.elements.mainNode,
          closeNode = this.elementHider.elements.closeNode;

      evt.initEvent('transitionend', false);

      closeNode.click();
      expect(this.hideSpy).to.have.been.called;
      expect(mainNode.classList.contains(this.elementHider.activeClass)).to.be.false;
      mainNode.dispatchEvent(evt);
      expect(document.body.querySelector(this.classMainNode)).to.be.null;
    });
  });

  describe('After a delay', function () {
    beforeEach(function (done) {
      var evt = document.createEvent('HTMLEvents');
      evt.initEvent('transitionend', false);

      setTimeout(function() {
        this.elementHider.elements.mainNode.addEventListener('transitionend', function() {});
        this.elementHider.elements.mainNode.dispatchEvent(evt);
        done();
      }.bind(this), this.delay);
    });

    it('should hide and remove the element from the DOM', function() {
      var mainNode = this.elementHider.elements.mainNode;
      expect(this.hideSpy).to.have.been.called;
      expect(mainNode.classList.contains(this.elementHider.activeClass)).to.be.false;
      expect(document.body.querySelector(this.classMainNode)).to.be.null;
    });
  });
});
