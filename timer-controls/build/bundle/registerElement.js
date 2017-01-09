module.exports = function (options) {
  var name = options.name;
  var lifecycle = options.lifecycle;
  var isBlock = options.isBlock || false;

  var prototype = Object.create(HTMLElement.prototype);
  Object.keys(lifecycle).forEach(function(property) {
    prototype[property] = lifecycle[property];
  });

  document.registerElement(name, { prototype: prototype });

  if (isBlock) {
    var style = document.createElement('style');
    style.textContent = name + '{display:block}';
    document.head.appendChild(style);
  }
};
