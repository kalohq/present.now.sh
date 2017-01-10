var registerElement = require('./registerElement');
var _ = require('private-parts').createKey();

var InlineInput = function(elements) {
  var root = elements.root;
  var input = elements.input;

  var self = {};

  self.receiveProp = function(prop, oldValue, newValue) {
    switch (prop) {
      case 'autofocus':
        if (oldValue === null && newValue !== null) {
          input.focus();
        }
        break;

      case 'value-on-blur':
        if (!input.textContent) {
          input.textContent = newValue;
        }
        break;

      default:
        break;
    }
  };

  self.change = function(event) {
    var value = input.textContent;

    if (value !== root.value) {
      root.value = value;
      root.dispatchEvent(new Event('input'));
    }
  };

  return self;
};

var selectOnFocus = function(event) {
  requestAnimationFrame(function() {
    var range = document.createRange();
    range.selectNodeContents(event.target);
    var selection = window.getSelection();
    selection.removeAllRanges();
    selection.addRange(range);
  });
};

registerElement({
  name: 'inline-input',
  lifecycle: {
    createdCallback: function() {
      var root = this;
      var input = document.createElement('span');
      input.setAttribute('contenteditable', '');
      input.className = 'inline-input›input';

      root.appendChild(input);
      var elements = {
        root: root,
        input: input,
      };

      var private = _(root);
      private.elements = elements;
      private.InlineInput = InlineInput(elements);

      var change = private.InlineInput.change;
      root.addEventListener('click', function() { input.focus(); });
      input.addEventListener('focus', selectOnFocus);
      input.addEventListener('keyup', change);
      input.addEventListener('paste', change);
      input.addEventListener('blur', function() {
        input.textContent = root.getAttribute('value-on-blur');
      });
    },

    attachedCallback: function() {
      var private = _(this);
      var input = private.elements.input;
      var change = private.InlineInput.change;
      var receiveProp = private.InlineInput.receiveProp;

      change({});
      receiveProp('autofocus', null, this.getAttribute('autofocus'));
      receiveProp('value', null, this.getAttribute('value'));
    },

    attributeChangedCallback: function(attribute, oldValue, newValue) {
      var private = _(this);
      private.InlineInput.receiveProp(attribute, oldValue, newValue);
    },
  },
});

var style = document.createElement('style');
style.textContent = (
  'inline-input .inline-input›input:focus {' +
    'outline: none;' +
  '}'
);
document.head.appendChild(style);
