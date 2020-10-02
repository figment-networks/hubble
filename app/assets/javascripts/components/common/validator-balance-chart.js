class ValidatorBalanceChart extends TimelineChart {
  constructor(target) {
    super(target);
    this.token = target.data('token');

    this.labelfunc = function(ylabel, date) {
      return `${ylabel.toFixed(2)} ${this.token} on ${moment.utc(date).format('ll')}`;
    };
  }
}

window.App.Common.ValidatorBalanceChart = ValidatorBalanceChart;
