describe('Article Components', function() {
  'use strict';

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'jquery',
      'ArticleComponents'
    ],
    function(
      $,
      ArticleComponents
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/ArticleComponents.html']).appendTo('body');
      self.$fixture = self.$html.find('[data-dough-component="ArticleComponents"]');
      self.ArticleComponents = ArticleComponents;
      self.$articleComponents = self.$fixture.find('[data-dough-article-component]');
      self.activeClass = 'is-active';

      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
  });

  describe('Set up component', function () {
    beforeEach(function(done) {
      this.component = new this.ArticleComponents(this.$fixture);
      this.component.init();
      done();
    });

    it('Should add the add/remove controls to the component', function() {
      var self = this;

      this.$articleComponents.each(function() {
        expect($(this).find('[data-dough-article-component-add]').length).to.equal(1);
        expect($(this).find('[data-dough-article-component-remove]').length).to.equal(1);
      });
    });
  });

  describe('Initial state', function() {
    beforeEach(function(done) {
      this.component = new this.ArticleComponents(this.$fixture);
      done();
    });

    it('Should set the appropriate active/inactive state on the component', function() {
      var self = this;

      this.$articleComponents.each(function() {
        self.component.init();
        expect($(this).hasClass(self.activeClass)).to.be.false;
        $(this).children('textarea').val('some content');
        self.component.init();
        expect($(this).hasClass(self.activeClass)).to.be.true;
      });
    });
  });

  describe('Add/Remove events', function() {
    beforeEach(function(done) {
      this.component = new this.ArticleComponents(this.$fixture);
      this.component.init();
      this.$control_add = this.$fixture.find('[data-dough-article-component-add]');
      this.$control_remove = this.$fixture.find('[data-dough-article-component-remove]');
      done();
    });

    it('Should add and remove components', function() {
      var self = this;

      this.$articleComponents.each(function() {
        self.$control_add.trigger('click');
        expect($(this).hasClass(self.activeClass)).to.be.true;
        $(this).children('textarea').val('some content');
        self.$control_remove.trigger('click');
        expect($(this).hasClass(self.activeClass)).to.be.false;
        expect($(this).children('textarea').val() === '').to.be.true
      });
    });
  });
});
