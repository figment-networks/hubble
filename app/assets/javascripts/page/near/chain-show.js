$(document).ready(function () {
  if (!_.includes(App.mode, 'chain-show')) { return }

  new App.Near.ValidatorTable($('.validator-table')).render()
  new App.Cosmoslike.SmallAverageBlockTimeChart($('.average-block-time-chart')).render()
  new App.Cosmoslike.TinyAverageActiveValidatorsChart($('.average-active-validators-chart')).render()
})
