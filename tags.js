//= require requirejs/require
//= require app/assets/javascripts/require_config.js.erb
//= require jquery.remotipart

require(['taggle'], function(Taggle) {
  'use strict';

  var taggle;

  // set 'active' class to selected letter tags link when clicking.
  $('.js-tags-starting-by-link').click(function() {
    $('.js-tags-starting-by-link').removeClass('active');
    $(this).addClass("active");
  });

  // update the list of tags starting by <prefix> if needed.
  function maybeUpdateDisplayedTagList(prefix) {
    if (displayedTagsPrefix() === prefix.toLowerCase()) {
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
    $(".js-tags-starting-by-link[data-prefix='" + prefix.toLowerCase() + "']").trigger('click');
  }

  // deletes a tag in the existing list from the server when clicking its 'x' on the corner.
  $('.js-tags-existing').on('click', 'a.close', function() {
    var tag_value = $(this).parent().find('.taggle_text').text();
    if (taggle.getTagValues().indexOf(tag_value) > -1) {
      taggle.remove(tag_value);
    } else {
      delete_tag(tag_value);
    }
  });

  // removes a tag from the server and updates the list of existing tags
  function delete_tag(value) {
    $('.js-tags-delete-value').val(value);
    $('.js-tags-delete-submit').click();
    maybeUpdateDisplayedTagList(value[0]);
  }


  // inits the tag box
  taggle = new Taggle(document.querySelector('.js-tags-display'), {
    placeholder: '',
    containerFocusClass: 'is-active',
    additionalTagClasses: 'tag',
    onTagAdd: function(event, tag) {
      var tagListNodes = taggle.getTags().elements;
      $('.js-tags-add-value').val(tag);
      $('.js-tags-add-submit').click();
      maybeUpdateDisplayedTagList(tag[0]);
      tagListNodes[tagListNodes.length - 1].querySelector('.close').setAttribute('tabIndex', -1);
    },
    onTagRemove: function(event, tag) {
      delete_tag(tag);
    }
  });
});
