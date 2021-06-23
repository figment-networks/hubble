class TransactionsVolumeChart extends SparklineChart {
  constructor(target, {scale = false}) {
    super(target);
    this.token = target.data('token');

    if (scale) {
      const rawData = target.data('chart');
      const [scale, prefix] = getScale(rawData);
      const scaledData = _.each(_.cloneDeep(rawData), (dp) => dp.y = dp.y / scale);
      this.token = `${prefix}${target.data('token')}`;
      this.data = scaledData;
    }

    this.labelfunc = function(ylabel, date) {
      return `${ylabel.toFixed(2)} ${this.token} on ${moment.utc(date).format('ll')}`;
    };
  }
}

window.App.Mina.TransactionsVolumeChart = TransactionsVolumeChart;
