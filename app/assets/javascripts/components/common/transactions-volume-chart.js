class TransactionsVolumeChart extends SparklineChart {
  constructor(target) {
    super(target);
    this.token = target.data('token');

    this.labelfunc = function(ylabel, date) {
      return `${ylabel.toFixed(2)} ${this.token} on ${moment.utc(date).format('ll')}`;
    };
  }
}

window.App.Common.TransactionsVolumeChart = TransactionsVolumeChart;
