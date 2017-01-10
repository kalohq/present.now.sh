!(function() {


  // THE REACT COMPONENT

  var h = React.createElement;
  var PropTypes = React.PropTypes;

  var TimerDisplay = React.createClass({
    propTypes: {
      paused: PropTypes.bool.isRequired,
      defaultColor: PropTypes.string.isRequired,
      pause: PropTypes.func.isRequired,
      colorBreakpoints: PropTypes.arrayOf(
        PropTypes.shape({
          color: PropTypes.string.isRequired,
          seconds: PropTypes.number.isRequired,
        })
      ).isRequired,
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
      var component = this;

      var secondsElapsed = Math.floor(this.state.millisecondsElapsed / 1000);
      var seconds = ('00' + secondsElapsed % 60).slice(-2);
      var minutes = ('00' + Math.min(
        Math.floor(secondsElapsed / 60),
        99
      )).slice(-2);

      var currentBreakpoint = this.props.colorBreakpoints.reduce(function(
        result, breakpoint
      ) {
        return (
          breakpoint.seconds >= result.seconds &&
          breakpoint.seconds <= secondsElapsed
        ) ? (
          breakpoint
        ) : (
          result
        );
      }, {
        color: this.props.defaultColor,
        seconds: 0,
      });

      return (
        h('div', {
          className: ('timer-display›background' +
            (!this.props.paused ? (
              ' timer-display›background»shown'
            ) : '')
          ),
          style: { backgroundColor: currentBreakpoint.color },
        },
          h('div', {
            className: 'timer-display›display',
          },
            minutes + ':' + seconds
          ),
          h('div', {
            className: 'timer-display›controls',
          },
            h('paper-icon-button', {
              icon: 'av:pause',
              onClick: function() { component.props.pause(); },
            })
          )
        )
      );
    },
  });


  // THE CUSTOM ELEMENT

  var renderInElement = function(element) {
    var hasColorBreakpoints = element.hasAttribute('color-breakpoints');
    ReactDOM.render(
      h(TimerDisplay, {
        paused: element.getAttribute('paused') !== null,
        defaultColor: element.getAttribute('default-color') || '#000000',
        pause: function() { element.setAttribute('paused', ''); },
        colorBreakpoints: hasColorBreakpoints ? (
          JSON.parse(element.getAttribute('color-breakpoints'))
        ) : (
          []
        ),
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
      (
        attribute === 'paused' ||
        attribute === 'default-color' ||
        attribute === 'color-breakpoints'
      ) &&
      newValue !== oldValue
    ) {
      renderInElement(this);
    }
  };

  TimerDisplayElement.detachedCallback = function() {
    ReactDOM.unmountComponentAtNode(this);
  };

  document.registerElement('timer-display', { prototype: TimerDisplayElement });
}());
