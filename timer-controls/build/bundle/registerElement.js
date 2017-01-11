module.exports = function (options) {
  const name = options.name;
  const lifecycle = options.lifecycle;
  const isBlock = options.isBlock || false;

  const prototype = Object.create(HTMLElement.prototype);
  Object.keys(lifecycle).forEach(function(property) {
    prototype[property] = lifecycle[property];
  });

  document.registerElement(name, { prototype: prototype });

  if (isBlock) {
    const style = document.createElement('style');
    style.textContent = name + '{display:block}';
    document.head.appendChild(style);
  }
};
