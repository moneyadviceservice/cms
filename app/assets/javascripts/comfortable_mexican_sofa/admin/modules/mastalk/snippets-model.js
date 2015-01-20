define([
  'text!snippet-collapsible',
  'text!snippet-ticks',
  'text!snippet-callout',
  'text!snippet-add-action',
  'text!snippet-video',
  'text!snippet-action-item',
  'text!snippet-table',
  'text!snippet-bullets'
], function (
    collapsibleSnippet,
    ticksSnippet,
    calloutSnippet,
    addActionSnippet,
    videoSnippet,
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
    video: videoSnippet,
    bullets: bulletsSnippet
  };

  return {
    get: function(type) {
      return snippets[type] || null;
    }
  };
});
