class TimelineChart {
  constructor(target) {
    this.target = target;
    this.data = target.data('chart');
    this.name = target.data('name');
  }

  render() {
    new Chart(this.target.get(0), {
      type: 'line',
      data: {
        labels: _.pick(this.data, 't'),
        datasets: [
          {
            data: this.data,
            fill: false,
            cubicInterpolationMode: 'monotone',
            steppedLine: false
          }
        ]
      },
      options: {
        elements: {
          line: {borderColor: '#4D74FF', borderWidth: 2},
          point: {radius: 3, borderColor: '#C8C8C8', backgroundColor: '#fff', hitRadius: 6, hoverRadius: 4}
        },
        maintainAspectRatio: false,
        legend: {display: false},
        title: {display: false},
        hover: {
          mode: 'nearest',
          intersect: true
        },
        tooltips: {
          enabled: false,
          mode: 'nearest',
          intersect: true,
          custom: window.customTooltip({minWidth: 250, top: 3, name: this.name}),
          callbacks: {
            label: (item, data) => {
              const date = data.datasets[item.datasetIndex].data[item.index].t;
              return this.labelfunc(item.yLabel, date);
            }
          }
        },
        scales: {
          yAxes: [
            {
              ticks: {
                min: 0,
                stepSize: 0
              }
            }
          ],
          xAxes: [
            {
              type: 'time',
              distribution: 'linear',
              time: {unit: 'day'},
              ticks: {maxRotation: 0, autoSkip: true}
            }
          ]
        }
      }
    });
  }
}

window.App.Common.TimelineChart = TimelineChart;
