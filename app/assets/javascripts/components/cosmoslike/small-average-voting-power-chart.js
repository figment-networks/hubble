class SmallAverageVotingPowerChart {
  constructor(target, interval) {
    this.target = target;
    this.interval = interval;
  }

  render() {
    const format = this.interval == 'last48h' ? 'k:mm' : 'MMM D';
    const data = App.seed.AVERAGE_VOTING_POWER[this.interval];

    // transform data.y's according to scale
    const [scale, prefix] = getScale(data);
    App.seed.PREFIXES = App.seed.PREFIXES || {};
    App.seed.PREFIXES[this.interval] = App.seed.PREFIXES[this.interval] || prefix;
    _.each(data, (dp) => dp.y = dp.y / scale);

    if (!data || _.isEmpty(data)) {
      this.target.parent().hide();
      return;
    }

    new Chart(this.target.get(0), {
      type: 'line',
      data: {
        labels: _.map(data, 't'),
        datasets: [
          {
            cubicInterpolationMode: 'monotone',
            data: data,
            borderColor: '#70707a',
            fill: false
          }
        ]
      },
      options: {
        elements: {
          point: {radius: 0, backgroundColor: '#70707a', hitRadius: 6, hoverRadius: 3}
        },
        layout: {
          padding: {top: 5, bottom: 5, left: 5, right: 5}
        },
        maintainAspectRatio: false,
        legend: {display: false},
        title: {display: false},
        hover: {
          mode: 'nearest',
          intersect: false
        },
        tooltips: {
          enabled: false,
          mode: 'nearest',
          intersect: false,
          custom: window.customTooltip({name: `sm-va-${this.interval}`, static: true}),
          callbacks: {
            label: (item, data) => {
              const date = data.datasets[item.datasetIndex].data[item.index].t;
              return `${+item.yLabel.toFixed(3)} ${App.seed.PREFIXES[this.interval]}${App.config.denom} voting power ` +
                     `${this.interval == 'last30d' ? 'on' : 'at'} ` +
                     `${moment.utc(date).format(format)}`;
            }
          }
        },
        scales: {
          yAxes: [
            {
              display: false,
              ticks: {display: false}
            }
          ],
          xAxes: [
            {
              display: false,
              ticks: {
                display: false,
                callback: (date) => moment(date).format('MMM-D hh:mm')
              }
            }
          ]
        }
      }
    });
  }
}

window.App.Cosmoslike.SmallAverageVotingPowerChart = SmallAverageVotingPowerChart;
