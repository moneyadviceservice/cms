//= require requirejs/require
//= require require_config
//= require jquery.remotipart

require(['taggle'], function(Taggle) {
  'use strict';

  // set 'active' class to selected letter tags link when clicking.
  $('.js-tags-starting-by-link').click(function() {
    $('.js-tags-existing .tag').removeClass('active');
    $(this).addClass("active");
  });

  // update the list of tags starting by <prefix> if needed.
  function maybeUpdateDisplayedTagList(prefix) {
    if (displayedTagsPrefix() == prefix) {
      displayTagList(prefix);
    }
  }

  // returns the prefix (letter) of the currently displayed tag list
  function displayedTagsPrefix() {
    var active_link = $('.js-tags-starting-by-link.active');
    if (active_link) {
      return active_link.attr('data-prefix');
    }
  }

  // render the list of tags starting by the given prefix (letter)
  function displayTagList(prefix) {
    $(".js-tags-starting-by-link[data-prefix*='" + prefix + "']")[0].click();
  }

  // inits the tag box
  new Taggle(document.querySelector('.js-tags-display'), {
    placeholder: '',
    onTagAdd: function(event, tag) {
      $('.js-tags-add-value').val(tag);
      $('.js-tags-add-submit').click();
      maybeUpdateDisplayedTagList(tag[0]);
    },
    onTagRemove: function(event, tag) {
      $('.js-tags-delete-value').val(tag);
      $('.js-tags-delete-submit').click();
      maybeUpdateDisplayedTagList(tag[0]);
    }
  });
});
