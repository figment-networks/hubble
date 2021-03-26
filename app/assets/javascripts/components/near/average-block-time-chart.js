class AverageBlockTimeChart extends SparklineChart {
  constructor(target) {
    super(target);
    let formatWith;
    let preposition;
    this.chartname = target.data('name');

    this.chartname === 'daily' ? (formatWith = 'll', preposition = 'on') : (formatWith = 'hh:mm', preposition = 'at');

    this.labelfunc = function(ylabel, date) {
      return `${ylabel.toFixed(2)}s ${preposition} ${moment.utc(date).format(formatWith)}`;
    };
  }
}
window.App.Near.AverageBlockTimeChart = AverageBlockTimeChart;
