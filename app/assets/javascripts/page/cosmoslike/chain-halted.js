$(document).ready( function() {
  if( !_.includes(App.mode, 'chain-halted') ) { return }

  new App.Cosmoslike.ValidatorTable( $('.validator-table') ).render()
} )
