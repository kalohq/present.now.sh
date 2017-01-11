var Elm = require('./elm');
var registerElement = require('./registerElement');
var _ = require('private-parts').createKey();

registerElement({
  name: 'timer-controls',
  isBlock: true,
  lifecycle: {
    attachedCallback: function() {
      var element = this;
      var app = Elm.Main.embed(element, {
        initialColor: this.getAttribute('initial-color'),
      });

      app.ports.sendInitialColor.subscribe(function(color) {
        element.dispatchEvent(new CustomEvent('initial-color', {
          detail: {color: color},
        }));
      });

      app.ports.sendColorBreakpoints.subscribe(function(breakpoints) {
        element.dispatchEvent(new CustomEvent('color-breakpoints', {
          detail: {breakpoints: breakpoints},
        }));
      });

      app.ports.startTimer.subscribe(function() {
        element.dispatchEvent(new Event('start-timer'));
      });

      _(this).app = app;
    },

    attributeChangedCallback: function(attribute, oldValue, newValue) {
      _(this).app.ports.receiveInitialColor.send(newValue);
    },
  },
});
