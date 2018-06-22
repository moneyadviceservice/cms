define(['jquery','DoughBaseComponent'], function ($, DoughBaseComponent) {
  'use strict';

  var ArticleComponentsProto,
      defaultConfig = {};

  function ArticleComponents($el, config) {
    ArticleComponents.baseConstructor.call(this, $el, config, defaultConfig);

    this.$articleComponents = $el.find('[data-dough-article-component]');
    this.activeClass = 'is-active';
  }

  DoughBaseComponent.extend(ArticleComponents);

  ArticleComponents.componentName = 'ArticleComponents';

  ArticleComponentsProto = ArticleComponents.prototype;

  ArticleComponentsProto.init = function(initialised) {
    this._initialisedSuccess(initialised);
    this._setUpComponent();
    this._checkInitialState();

    return this;
  };

  ArticleComponentsProto._setUpComponent = function() {
    var self = this,
        component_add =
          '<button class="article-component--add button button--secondary button--action">' +
            '<span class="button__text" data-dough-article-component-add>Add</a>' +
          '</button>',
        component_remove =
          '<a data-dough-article-component-remove class="article-component--remove" href="#">' +
            '<span class="fa fa-remove remove--icon"></span><span>Remove</span>' +
          '</a>';

    this.$articleComponents.each(function() {
      var component = this;

      $(this)
        .append(component_remove)
        .children('label').append(component_add);

      var add = $(component).find('[data-dough-article-component-add]');
      var remove = $(component).find('[data-dough-article-component-remove]');

      $(add).on('click', function(e) {
        e.preventDefault();
        self._addComponent(component);
      });

      $(remove).on('click', function(e) {
        e.preventDefault();
        self._removeComponent(component);
      });
    });
  };

  ArticleComponentsProto._checkInitialState = function() {
    var self = this;

    this.$articleComponents.each(function() {
      if ($(this).children('textarea').val() !== '') {
        $(this).addClass(self.activeClass);
      }
    });
  };

  ArticleComponentsProto._addComponent = function(component) {
    $(component).addClass(this.activeClass);
  }

  ArticleComponentsProto._removeComponent = function(component) {
    $(component).removeClass(this.activeClass);
    $(component).children('textarea').val('');
  }

  return ArticleComponents;
});
