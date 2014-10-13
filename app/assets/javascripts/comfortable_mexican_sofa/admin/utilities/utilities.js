define('utilities', [], function () {
  'use strict';

  return {
    // Methods
    getSupportedPropertyName: function(properties) {
      var i;
      for (i = 0; i < properties.length; i++) {
        var div = document.createElement('div');
        if (typeof div.style[properties[i]] !== 'undefined') {
          return properties[i];
        }
      }
      return null;
    }
  };
});
