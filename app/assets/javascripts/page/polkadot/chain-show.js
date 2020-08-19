$(document).ready(function () {
  if (!_.includes(App.mode, 'chain-show')) { return }

  new App.Polkadot.ValidatorTable($('.validator-table'), ['state']).render()
  new App.Polkadot.SmallValidatorTotalStakeChart($('.validator-daily-stake-chart')).render()
})
