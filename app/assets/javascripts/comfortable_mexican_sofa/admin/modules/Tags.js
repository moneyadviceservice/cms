define(['jquery','DoughBaseComponent','taggle'], function ($, DoughBaseComponent, Taggle) {
  'use strict';

  var TagsProto,
      defaultConfig = {
        uiEvents: {}
      };

  function Tags($el, config) {
    Tags.baseConstructor.call(this, $el, config, defaultConfig);
  }

  DoughBaseComponent.extend(Tags);
  TagsProto = Tags.prototype;

  TagsProto.init = function(initialised) {
    var taggle;

    // update the list of tags starting by <prefix> if needed.
    function maybeUpdateDisplayedTagList(prefix) {
      if (displayedTagsPrefix() == prefix.toLowerCase()) {
        displayTagList(prefix);
      }
    }

    // returns the prefix (letter) of the currently displayed tag list
    function displayedTagsPrefix() {
      var active_link = $('.js-tags-starting-by-link.active');
      if (active_link.length > 0) {
        return active_link.attr('data-prefix');
      }
    }

    // render the list of tags starting by the given prefix (letter)
    function displayTagList(prefix) {
      $(".js-tags-starting-by-link[data-prefix='" + prefix.toLowerCase() + "']").click();
    }

    // deletes a tag in the existing list from the server when clicking its 'x' on the corner.
    $('.js-tags-existing').on('click', 'a.close', function() {
      var tag_value = $(this).parent().find('.taggle_text').text();
      if (taggle.getTagValues().indexOf(tag_value) > -1) {
        taggle.remove(tag_value);
      }
      delete_tag_from_server(tag_value);
    });

    $('.js-tags-add-form').on("ajax:success", function (e, data, status, xhr) {
      var value = $('.js-tags-add-value').val();
      maybeUpdateDisplayedTagList(value[0]);
    });

    $('.js-tags-delete-form').on("ajax:success", function (e, data, status, xhr) {
      var value = $('.js-tags-delete-value').val();
      maybeUpdateDisplayedTagList(value[0]);
    });

    // set 'active' class to selected letter tags link when clicking.
    $('.js-tags-starting-by-link').on("ajax:success", function (e, data, status, xhr) {
      $('.js-tags-starting-by-link').removeClass('active');
      $(this).addClass("active");
    });

    // creates a tag in the server and updates the list of existing tags
    function create_tag_in_server(value) {
      $('.js-tags-add-value').val(value);
      $('.js-tags-add-submit').click();
    }

    // removes a tag from the server and updates the list of existing tags
    function delete_tag_from_server(value) {
      $('.js-tags-delete-value').val(value);
      $('.js-tags-delete-submit').click();
    }


    // inits the tag box
    taggle = new Taggle(document.querySelector('.js-tags-display'), {
      placeholder: '',
      containerFocusClass: 'is-active',
      additionalTagClasses: 'tag',
      onTagAdd: function(event, tag) {
        var tagListNodes = taggle.getTags().elements;
        create_tag_in_server(tag);
        tagListNodes[tagListNodes.length - 1].querySelector('.close').setAttribute('tabIndex', -1);
      }
    });

    this._initialisedSuccess(initialised);

    return this;
  };

  return Tags;
});
