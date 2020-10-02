class HourlyUptimeChart extends TimelineChart {
  constructor(target) {
    super(target);

    this.labelfunc = function(ylabel, date) {
      return `${ylabel}% at ${moment.utc(date).format('k:mm')}`;
    };
  }
}

window.App.Common.HourlyUptimeChart = HourlyUptimeChart;
