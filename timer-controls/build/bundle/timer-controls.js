var Elm = require('./elm');
var registerElement = require('./registerElement.js');
var _ = require('private-parts').createKey();

registerElement({
  name: 'timer-controls',
  isBlock: true,
  lifecycle: {
    attachedCallback: function () {
      var element = this;
      var app = Elm.Main.embed(element, {
        initialColor: this.getAttribute('initial-color'),
      });

      app.ports.sendInitialColor.subscribe(function (color) {
        var event = new CustomEvent('initial-color', {
          detail: {color: color},
        });
        element.dispatchEvent(event);
      });

      _(this).app = app;
    },

    attributeChangedCallback: function(attribute, oldValue, newValue) {
      _(this).app.ports.receiveInitialColor.send(newValue);
    },
  },
});
