describe('WordCount', function() {
  'use strict';

  var sandbox;

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'jquery',
      'WordCount',
      'eventsWithPromises'
    ],
    function(
      $,
      WordCount,
      eventsWithPromises
    ) {
      sandbox = sinon.sandbox.create();
      self.$html = $(window.__html__['spec/javascripts/fixtures/WordCount.html']).appendTo('body');
      self.$fixture = $('body').find('[data-dough-component="WordCount"]');
      self.WordCount = WordCount;
      self.eventsWithPromises = eventsWithPromises;
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
    sandbox.restore();
    this.eventsWithPromises.unsubscribeAll();
  });

  describe('Initialisation', function() {
    beforeEach(function(done) {
      this.component = new this.WordCount(this.$fixture);
      this.component.init();
      done();
    });

    it('should cache all required DOM elements', function() {
      expect(this.component.$display.length).to.be.at.least(1);
    });
  });

  describe('updating content', function () {
    beforeEach(function(done) {
      this.component = new this.WordCount(this.$fixture);
      done();
    });

    it('should display the approximate number of words entered', function() {
      var $display;

      this.component.init();

      $display = this.component.$display.eq(0);

      this.component.$el.text('foo bar baz').trigger('input');

      expect($display).to.have.text('You have approximately 3 words!');
    });

    it('should filter out any MASTalk snippet code and display the approximate number of words entered', function() {
      var $display,
          text = 'Lorem ipsum dolor sit amet, consectetur. '+

                  '$yes-no ' +
                  '[y] yes [/y] ' +
                  '[n] no [/n] ' +
                  '$end' +

                  '$bullet ' +
                  '[%] point 1 [/%] ' +
                  '[%] point 2 [/%] ' +
                  '$point' +

                  '| Equity loans | Mortgage guarantees ' +
                  '|---|--- ' +
                  '| New-build properties | New-build and pre-owned properties ' +
                  '| Minimum 5% deposit | Minimum 5% deposit' +

                  '({EMBED_CODE})' +

                  '[[BRIGHTCOVE_ID]]' +

                  '$action ' +
                  '## Header ' +
                  '$collapsable ' +
                  '$why ' +
                  '### Why? ' +
                  'Your Cash ISA allowance' +
                  '$why ' +
                  '$how ' +
                  '### How? ' +
                  'If you already have an ISA ' +
                  '$how ' +
                  '$collapsable ' +
                  '$item' +

                  '$~callout' +
                  'Did you know?' +
                  '~$' +

                  '^ Cash savings comparison tables^';

      this.component.init();

      $display = this.component.$display.eq(0);

      this.component.$el.text(text).trigger('input');

      expect($display).to.have.text('You have approximately 70 words!');
    });
  });

  describe('changing editing mode to Markdown', function () {
    beforeEach(function(done) {
      this.component = new this.WordCount(this.$fixture);
      done();
    });

    it('should hide the word count', function() {
      this.component.init();
      expect(this.component.$display.hasClass(this.component.config.selectors.hiddenClass)).to.be.false;
      this.eventsWithPromises.publish('content:updated', 'markdown');
      expect(this.component.$display.hasClass(this.component.config.selectors.hiddenClass)).to.be.true;
    });
  });
});
