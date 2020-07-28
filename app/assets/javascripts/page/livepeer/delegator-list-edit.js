$(document).ready( function() {
  if( !_.includes(App.mode, 'delegator-list-edit') ) { return }

  new App.Livepeer.DelegatorListForm( $('.delegator-list-form') ).render()
} )
