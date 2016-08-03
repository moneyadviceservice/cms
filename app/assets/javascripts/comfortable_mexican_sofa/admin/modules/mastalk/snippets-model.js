define([], function () {
  'use strict';

  var snippets = {
    actionItem: '$action\r\n## Header\r\n$collapsable\r\n$why\r\n  ### Why?\r\n  Your \'Cash ISA allowance\r\n$why\r\n$how\r\n  ### How?\r\n  If you already have an ISA\r\n$how\r\n$collapsable\r\n$item',
    addAction: '^[Help to Buy schemes FAQs](\/en\/articles\/help-to-buy-schemes-faqs)^',
    bullets: '$bullet\r\n[%] point 1 [\/%]\r\n[%] point 2 [\/%]\r\n$point',
    collapsible: '$=\r\n# Before you borrow\r\n=$\r\n\r\n$-\r\nFind out if you need to borrow money and whether you can afford it. Learn how to work out the true cost of borrowing.\r\n\r\nTaking control of debt\r\n\r\nWhere to get free debt advice, how to speak to the people you owe money to, and tips to help you pay back your debts in the right order.\r\n-$',
    callout: '$~callout\r\n# Budgeting tips\r\nIn 1985, average first-time buyers needed a deposit of 5% to buy a home - in 2012, this had increased to 20%\r\n*Source: HMS Treasury*\r\n~$\r\n',
    promoBlock: '$bl\r\n\r\n$bl_m\r\n\r\nbl_m$\r\n\r\n$bl_c\r\n\r\nbl_c$\r\n\r\nbl$',
    table: '| Equity loans | Mortgage guarantees\r\n|---|---\r\n | New-build properties | New-build and pre-owned properties\r\n| Minimum 5% deposit | Minimum 5% deposit',
    ticks: '$yes-no\r\n[y] yes [\/y]\r\n[n] no [\/n]\r\n$end',
    videoYoutube: '$~youtube_video\r\nVIDEO_ID\r\nA title for the video\r\n~$',
    videoBrightcove: '$~brightcove_video\r\nVIDEO_ID\r\nA title for the video\r\n~$',
    videoVimeo: '$~vimeo_video\r\nVIDEO_ID\r\nA title for the video\r\n~$',
    costCalculator: '$~cost-calc\r\nCALCULATOR_ID\r\n~$'
  };

  return {
    get: function(type) {
      return snippets[type] || null;
    }
  };
});
