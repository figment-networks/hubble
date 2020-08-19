class ValidatorVotingPowerHistory {
  constructor( target ) {
    this.target = target
  }

  render() {
    if( !App.seed.VOTING_POWER_HISTORY || _.isEmpty(App.seed.VOTING_POWER_HISTORY) ) {
      this.target.parents('.data-block').hide()
      return
    }

    const rawData = App.seed.VOTING_POWER_HISTORY

    // transform data.y's according to scale
    const [scale, prefix] = getScale( rawData )
    const scaledData = _.each( _.cloneDeep(rawData), ( dp ) => dp.y = dp.y / scale )

    const max = Math.ceil( _.maxBy( scaledData, dp => dp.y ).y * 1.5 )
    // const min = Math.floor( _.minBy( data, dp => dp.y ).y * 0.5 )

    const annotations = []

    let i = 0
    const total = App.seed.ACTIVE_SET_HISTORY.length
    while( i < total ) {
      const ash = App.seed.ACTIVE_SET_HISTORY[i]
      if( ash.inout == 'out' ) {
        // draw until next in
        let drawToIndex = _.findIndex(
          App.seed.ACTIVE_SET_HISTORY,
          (ash => ash.inout == 'in'),
          i+1
        )
        let drawTo = App.seed.ACTIVE_SET_HISTORY[drawToIndex]
        i = drawToIndex

        if( !drawTo ) {
          // draw to end of graph
          drawTo = _.last( scaledData )
          i = total
        }

        annotations.push( {
          type: 'box',
          xScaleID: 'x-axis-0',
          yScaleID: 'y-axis-0',
          xMin: ash.t,
          xMax: drawTo.t,
          backgroundColor: 'rgba(180,0,0,0.3)',
          borderWidth: 0
        } )
      }
      i++
    }

    const ctx = this.target.get(0).getContext('2d')
    new Chart( ctx, {
      type: 'line',
      data: {
        labels: _.pick( scaledData, 't' ),
        datasets: [
          {
            data: scaledData,
            fill: false,
            cubicInterpolationMode: 'monotone',
            steppedLine: false
          }
        ]
      },
      options: {
        elements: {
          line: {borderColor: '#4D74FF', borderWidth: 2},
          point: { radius: 3, borderColor: '#C8C8C8', backgroundColor: '#fff', hitRadius: 6 , hoverRadius: 4 }
        },
        layout: {
          padding: { top: 5, bottom: 5, left: 5, right: 5 }
        },

        annotation: {
          drawTime: 'afterDraw',
          annotations: annotations
        },

        maintainAspectRatio: false,
        legend: { display: false },
        title: { display: false },
        hover: {
          mode: 'nearest',
          intersect: true
        },
        tooltips: {
          enabled: false,
          mode: 'nearest',
          intersect: true,
          custom: window.customTooltip( { top: 3, minWidth: 250 } ),
          callbacks: {
            label: ( item, data ) => {
              const height = data.datasets[item.datasetIndex].data[item.index].h
              const date = data.datasets[item.datasetIndex].data[item.index].t
              const parts = _.compact( [
                `<label>Voting Power:</label> ${+item.yLabel.toFixed(3)} ${prefix}${App.config.denom}<br/>`,
                height ? `<label>Block Height:</label> ${height}<br/>` : null,
                `<label>Timestamp:</label> ${moment.utc(date).format('MMM-D k:mm')}`
              ] )
              return parts.join('')
            }
          }
        },
        scales: {
          yAxes: [
            {
              ticks: {
                max, min: 0,
                stepSize: 500,
                callback: (value) => value != Math.ceil(value / 500) * 500 ? '' : value
              }
            }
          ],
          xAxes: [
            {
              type: 'time',
              distribution: 'linear',
              time: { unit: 'day' },
              ticks: { maxRotation: 0, autoSkip: true }
            }
          ]
        }
      }
    } )
  }
}

window.App.Cosmoslike.ValidatorVotingPowerHistory = ValidatorVotingPowerHistory
