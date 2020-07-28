$(document).ready( function() {
  if( !_.includes(App.mode, 'delegator-list-index') ) { return }

  new App.Livepeer.DelegatorListsTable( $('.delegator-lists-table') ).render()
} )
