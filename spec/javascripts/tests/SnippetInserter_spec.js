describe('SnippetInserter', function() {
  'use strict';

  var sandbox;

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'phantom-shims',
      'jquery',
      'SnippetInserter'
    ],
    function (
      phantomShims,
      $,
      SnippetInserter
    ) {
      sandbox = sinon.sandbox.create();

      self.$html = $(window.__html__['spec/javascripts/fixtures/SnippetInserter.html']).appendTo('body');
      self.$fixture = self.$html.find('[data-dough-component="SnippetInserter"]');
      self.SnippetInserter = SnippetInserter;

      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
    sandbox.restore();
  });

  describe('Initialisation', function() {
    beforeEach(function (done) {
      this.component = new this.SnippetInserter(this.$fixture);
      done();
    });

    it('should cache at least one insert trigger', function() {
      this.component.init();
      expect(this.component.$triggers.length).to.be.at.least(1);
    });
  });

  describe('#_insertSnippet', function () {
    beforeEach(function (done) {
      var model = {
        data: {
          test: 'testvalue'
        },
        get: function(type) {
          return this.data[type || null];
        }
      };
      this.component = new this.SnippetInserter(this.$fixture, null, null, model);
      this.component.init();
      done();
    });

    it('should call insertSnippet with the model data', function() {
      var spy = sandbox.spy(this.SnippetInserter.prototype, 'insertAtCursor');

      this.component._insertSnippet('test');
      expect(spy.calledWith(this.component.$el[0], 'testvalue')).to.be.true;
    });
  });

  describe('#insertAtCursor', function () {
    beforeEach(function (done) {
      this.component = new this.SnippetInserter(this.$fixture);
      this.component.init();

      done();
    });

    it('should insert text at the cursor position within a text field', function() {
      var defaultValue = 'foo',
          insertedValue = 'bar',
          target = this.component.$el[0];

      this.component.$el.val(defaultValue);
      target.focus();
      target.selectionStart = target.value.length;
      this.component.insertAtCursor(target, insertedValue);

      expect(this.component.$el.val()).to.equal(defaultValue + insertedValue);
    });
  });
});

