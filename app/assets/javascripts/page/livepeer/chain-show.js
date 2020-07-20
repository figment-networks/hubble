$(document).ready( function() {
  if( !_.includes(App.mode, 'chain-show') ) { return }

  new App.Livepeer.TranscodersTable( $('.transcoders-table') ).render()
} )
