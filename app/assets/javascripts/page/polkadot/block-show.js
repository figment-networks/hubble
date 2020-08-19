$(document).ready( function() {
  if( !_.includes(App.mode, 'block-show') ) { return }

  new App.Polkadot.TransactionsTable( $('.transactions-table') ).render()
  new App.Polkadot.ValidatorTable($('.validator-table'), ['uptime']).render()
} )
