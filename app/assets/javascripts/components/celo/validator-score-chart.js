class ValidatorScoreChart extends TimelineChart {
  constructor(target) {
    super(target);

    this.labelfunc = function(ylabel, date) {
      return `${ylabel}% on ${moment.utc(date).format('ll')}`;
    };
  }
}

window.App.Celo.ValidatorScoreChart = ValidatorScoreChart;
