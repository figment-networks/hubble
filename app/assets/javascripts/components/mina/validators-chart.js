class ValidatorsChart extends SparklineChart {
  constructor(target) {
    super(target);

    this.pointOpts = {
      radius: 0, backgroundColor: 'white', hitRadius: 10, hoverRadius: 3
    };

    this.labelfunc = function(ylabel, date) {
      const duration = moment.duration(moment().diff(date));
      const hours = Math.ceil(duration.asHours());
      return `${ylabel.toFixed(0)} active at ${hours.toFixed(0)} hour${hours == 1 ? '' : 's'} ago`;
    };
  }
}

window.App.Mina.ValidatorsChart = ValidatorsChart;
