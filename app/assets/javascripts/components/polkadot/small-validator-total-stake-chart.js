class SmallValidatorTotalStakeChart {
  constructor( target ) {
    this.target = target
  }

  render() {
    if( !App.seed.VALIDATOR_TOTAL_STAKE || _.isEmpty(App.seed.VALIDATOR_TOTAL_STAKE) ) {
      this.target.parent().hide()
      return
    }

    new Chart( this.target.get(0), {
      type: 'line',
      data: {
        labels: _.map( App.seed.VALIDATOR_TOTAL_STAKE, dp => dp.t ),
        datasets: [
          {
            cubicInterpolationMode: 'monotone',
            data: App.seed.VALIDATOR_TOTAL_STAKE,
            borderColor: '#70707a',
            fill: false
          }
        ]
      },
      options: {
        elements: {
          point: { radius: 0, backgroundColor: '#70707a', hitRadius: 6, hoverRadius: 3 }
        },
        layout: {
          padding: { top: 5, bottom: 5, left: 5, right: 5 }
        },
        maintainAspectRatio: false,
        legend: { display: false },
        title: { display: false },
        hover: {
          mode: 'nearest',
          intersect: false
        },
        tooltips: {
          enabled: false,
          mode: 'nearest',
          intersect: false,
          custom: window.customTooltip( { top: -55, name: 'sm-bta', static: true } ),
          callbacks: {
            label: ( item, data ) => {
              const date = data.datasets[item.datasetIndex].data[item.index].t
              return `${item.yLabel} ${App.config.denom} on ` + date
            }
          }
        },
        scales: {
          yAxes: [
            {
              display: false,
              ticks: { display: false, stepSize: 1 }
            }
          ],
          xAxes: [
            {
              display: false,
              ticks: {
                display: false,
                callback: ( date ) => moment(date).format('MMM-D hh:mm')
              }
            }
          ]
        }
      }
    } )
  }
}

window.App.Polkadot.SmallValidatorTotalStakeChart = SmallValidatorTotalStakeChart
