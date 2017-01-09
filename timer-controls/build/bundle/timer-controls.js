var Elm = require('./elm');
var defineCustomElement = require('./defineCustomElement.js');

defineCustomElement({
  name: 'timer-controls',
  isBlock: true,
  lifecycle: {
    createdCallback: function () {
      Elm.Main.embed(this);
    },
  },
});
