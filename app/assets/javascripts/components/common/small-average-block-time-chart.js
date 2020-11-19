class SmallAverageBlockTimeChart {
  constructor(target) {
    this.target = target;
    if (!App.seed.AVERAGE_BLOCK_TIME) {
      App.seed.AVERAGE_BLOCK_TIME = target.data('chart');
    }
  }

  render() {
    if (!App.seed.AVERAGE_BLOCK_TIME || _.isEmpty(App.seed.AVERAGE_BLOCK_TIME)) {
      this.target.parent().hide();
      return;
    }

    new Chart(this.target.get(0), {
      type: 'line',
      data: {
        labels: _.map(App.seed.AVERAGE_BLOCK_TIME, (dp) => dp.t),
        datasets: [
          {
            cubicInterpolationMode: 'monotone',
            data: App.seed.AVERAGE_BLOCK_TIME,
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
          custom: window.customTooltip({top: -55, name: 'sm-bta', static: true}),
          callbacks: {
            label: (item, data) => {
              const date = data.datasets[item.datasetIndex].data[item.index].t;
              return `${item.yLabel.toFixed(2)}s ` +
                     `${this.interval == 'day' ? 'on' : 'at'} ` +
                     `${moment.utc(date).format('k:mm')}`;
            }
          }
        },
        scales: {
          yAxes: [
            {
              display: false,
              ticks: {display: false, stepSize: 1}
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

window.App.Common.SmallAverageBlockTimeChart = SmallAverageBlockTimeChart;
