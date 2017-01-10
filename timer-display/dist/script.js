!(function() {


  // THE REACT COMPONENT

  var h = React.createElement;
  var PropTypes = React.PropTypes;

  var TimerDisplay = React.createClass({
    propTypes: {
      paused: PropTypes.bool.isRequired,
    },

    getInitialState: function() {
      requestAnimationFrame(this.tick);

      return {
        lastTick: Date.now(),
        millisecondsElapsed: 0,
      };
    },

    tick: function() {
      requestAnimationFrame(this.tick);

      var now = Date.now();

      if (this.props.paused) {
        this.setState({
          lastTick: now,
        });
      } else {
        this.setState({
          millisecondsElapsed: (
            this.state.millisecondsElapsed +
            (now - this.state.lastTick)
          ),
          lastTick: now,
        });
      }
    },

    render: function() {
      var secondsElapsed = Math.floor(this.state.millisecondsElapsed / 1000);
      var seconds = ('00' + secondsElapsed % 60).slice(-2);
      var minutes = ('00' + Math.min(
        Math.floor(secondsElapsed / 60),
        99
      )).slice(-2);

      return (
        h('div', null,
          minutes + ':' + seconds
        )
      );
    },
  });


  // THE CUSTOM ELEMENT

  var renderInElement = function(element) {
    ReactDOM.render(
      h(TimerDisplay, {
        paused: element.getAttribute('paused') !== null,
      }),
      element
    );
  };

  var TimerDisplayElement = Object.create(HTMLElement.prototype);

  TimerDisplayElement.attachedCallback = function() {
    renderInElement(this);
  };

  TimerDisplayElement.attributeChangedCallback = function(
    attribute, oldValue, newValue
  ) {
    if (
      attribute === 'paused' &&
      newValue !== oldValue
    ) {
      renderInElement(this);
    }
  };

  TimerDisplayElement.detachedCallback = function() {
    renderInElement(this);
  };

  document.registerElement('timer-display', { prototype: TimerDisplayElement });

  var style = document.createElement('style');
  style.textContent = 'timer-display{' + [
    'position:absolute',
    'top:0',
    'right:0',
    'bottom:0',
    'left:0',
  ].join(';') + '}';
}());
