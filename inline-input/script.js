!(function() {


  // THE LOGIC

  const InlineInput = function(elements) {
    const root = elements.root;
    const input = elements.input;

    const self = {};

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

    self.change = function(event, options) {
      const value = input.textContent;

      if (value !== root.value) {
        root.value = value;

        if (!options || !options.initialPass) {
          root.dispatchEvent(new Event('input'));
        }
      }
    };

    return self;
  };

  const selectOnFocus = function(event) {
    requestAnimationFrame(function() {
      const range = document.createRange();
      range.selectNodeContents(event.target);
      const selection = window.getSelection();
      selection.removeAllRanges();
      selection.addRange(range);
    });
  };

  const style = document.createElement('style');
  style.textContent = (
    'inline-input .inline-input›input:focus {' +
      'outline: none;' +
    '}'
  );


  // THE CUSTOM ELEMENT

  const privateStuff = new Map();

  const prototype = Object.create(HTMLElement.prototype);
  prototype.createdCallback: function() {
    const root = this;
    const input = document.createElement('span');
    input.setAttribute('contenteditable', '');
    input.className = 'inline-input›input';

    root.appendChild(input);
    const elements = {
      root: root,
      input: input,
    };

    const private = privateStuff.get(root);
    private.elements = elements;
    private.InlineInput = InlineInput(elements);

    const change = private.InlineInput.change;
    root.addEventListener('click', function() { input.focus(); });
    input.addEventListener('focus', selectOnFocus);
    input.addEventListener('keyup', change);
    input.addEventListener('paste', change);
    input.addEventListener('blur', function() {
      input.textContent = root.getAttribute('value-on-blur');
    });
  },

  prototype.attachedCallback: function() {
    const private = privateStuff.get(this);
    const input = private.elements.input;
    const change = private.InlineInput.change;
    const receiveProp = private.InlineInput.receiveProp;

    change({}, { initialPass: true });
    receiveProp('autofocus', null, this.getAttribute('autofocus'));
    receiveProp('value', null, this.getAttribute('value'));
  },

  prototype.attributeChangedCallback: function(attribute, oldValue, newValue) {
    const private = privateStuff.get(this);
    private.InlineInput.receiveProp(attribute, oldValue, newValue);
  },

  document.registerElement('inline-input', prototype);
  document.head.appendChild(style);
}());
