class TinyAverageActiveValidatorsChart {
  constructor(target) {
    this.target = target;
  }

  render() {
    if (!App.seed.AVERAGE_ACTIVE_VALIDATORS || _.isEmpty(App.seed.AVERAGE_ACTIVE_VALIDATORS)) {
      this.target.parent().hide();
      return;
    }

    new Chart(this.target.get(0), {
      type: 'line',
      data: {
        labels: _.map(App.seed.AVERAGE_ACTIVE_VALIDATORS, (dp) => dp.t),
        datasets: [
          {
            cubicInterpolationMode: 'monotone',
            data: App.seed.AVERAGE_ACTIVE_VALIDATORS,
            borderColor: '#4D74FF',
            fill: false
          }
        ]
      },
      options: {
        elements: {
          point: {radius: 0, backgroundColor: '#4D74FF', hitRadius: 10, hoverRadius: 3}
        },
        layout: {
          padding: {top: 5, bottom: 5, left: 10, right: 5}
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
          custom: window.customTooltip({top: -40, name: 't-av', static: true}),
          callbacks: {
            label: (item, data) => {
              const date = data.datasets[item.datasetIndex].data[item.index].t;
              const duration = moment.duration(moment().diff(date));
              const hours = Math.ceil(duration.asHours());
              return `${item.yLabel.toFixed(0)} active at ${hours.toFixed(0)} hour${hours == 1 ? '' : 's'} ago`;
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

window.App.Cosmoslike.TinyAverageActiveValidatorsChart = TinyAverageActiveValidatorsChart;
