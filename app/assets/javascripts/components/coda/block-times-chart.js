class BlockTimesChart extends SparklineChart {
  constructor(target, interval) {
    super(target);

    this.interval = interval;
    this.labelfunc = this.labelfunc = function(ylabel, date) {
      const interval = this.interval == 'day' ? 'on' : 'at';
      return `${ylabel.toFixed(2)}s ${interval} ${moment.utc(date).format('k:mm')}`;
    };
  }
}

window.App.Coda.BlockTimesChart = BlockTimesChart;
