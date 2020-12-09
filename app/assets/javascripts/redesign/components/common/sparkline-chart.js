class SparklineChart {
  constructor(target) {
    this.target = target;
    this.data = target.data('chart');
    this.name = target.data('name');
  }

  render() {
    if (!this.data) {
      this.target.parent().hide();
      return;
    }

    const pointOpts = this.pointOpts || {
      radius: 0,
      backgroundColor: '#4D74FF',
      hitRadius: 6,
      hoverRadius: 3
    };

    new Chart(this.target.get(0), {
      type: 'line',
      data: {
        labels: _.map(this.data, (dp) => dp.t),
        datasets: [
          {
            cubicInterpolationMode: 'monotone',
            data: this.data,
            borderColor: pointOpts.backgroundColor,
            fill: false
          }
        ]
      },
      options: {
        elements: {
          point: pointOpts
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
          custom: window.customTooltip({
            top: -55,
            name: this.name || 'sm-bta',
            static: true
          }),
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

window.App.Common.SparklineChart = SparklineChart;
