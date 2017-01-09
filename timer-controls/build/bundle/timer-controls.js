var Elm = require('./elm');
var defineCustomElement = require('./defineCustomElement.js');

defineCustomElement({
  name: 'timer-controls',
  isBlock: true,
  lifecycle: {
    createdCallback: function () {
      var element = this;
      var app = Elm.Main.embed(element);

      app.ports.sendInitialColor.subscribe(function (color) {
        var event = new CustomEvent('initial-color', {
          detail: {color: color},
        });
        element.dispatchEvent(event);
      })
    },
  },
});
