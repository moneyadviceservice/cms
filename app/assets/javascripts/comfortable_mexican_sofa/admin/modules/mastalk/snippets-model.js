define([
  'text!snippets/collapsible.md',
  'text!snippets/ticks.md',
  'text!snippets/callout.md',
  'text!snippets/add-action.md',
  'text!snippets/video-youtube.md',
  'text!snippets/video-brightcove.md',
  'text!snippets/action-item.md',
  'text!snippets/table.md',
  'text!snippets/bullets.md'
], function (
    collapsibleSnippet,
    ticksSnippet,
    calloutSnippet,
    addActionSnippet,
    videoYoutubeSnippet,
    videoBrightcoveSnippet,
    actionItemSnippet,
    tableSnippet,
    bulletsSnippet
  ) {
  'use strict';

  var snippets = {
    actionItem: actionItemSnippet,
    addAction: addActionSnippet,
    collapsible: collapsibleSnippet,
    callout: calloutSnippet,
    table: tableSnippet,
    ticks: ticksSnippet,
    videoYoutube: videoYoutubeSnippet,
    videoBrightcove: videoBrightcoveSnippet,
    bullets: bulletsSnippet
  };

  return {
    get: function(type) {
      return snippets[type] || null;
    }
  };
});
