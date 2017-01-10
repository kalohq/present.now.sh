(function() {


  // COLOR OF HEADER

  var vibrantMaterialColors = [
    "#f44336", // red
    "#e91e63", // pink
    "#9c27b0", // purple
    "#673ab7", // deepPurple
    "#3f51b5", // indigo
    "#2196f3", // blue
    "#03a9f4", // lightBlue
    "#00bcd4", // cyan
    "#009688", // teal
    "#4caf50", // green
    "#8bc34a", // lightGreen
    "#cddc39", // lime
    "#ffc107", // amber
    "#ff9800", // orange
    "#ff5722", // deepOrange
  ];

  var headerColor = vibrantMaterialColors[
    Math.floor(Math.random() * vibrantMaterialColors.length)
  ];

  window.presentNowSh = window.presentNowSh || {};

  var headerStyle = document.createElement('style');
  document.head.appendChild(headerStyle);
  presentNowSh.setHeaderColor = function(color) {
    headerStyle.textContent = '.control-panel h1{color:' + color + '}';
  };
  presentNowSh.setHeaderColor(headerColor);

  presentNowSh.headerColor = headerColor;
}());
