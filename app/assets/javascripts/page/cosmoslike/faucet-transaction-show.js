$(document).ready( function() {
  if( !_.includes(App.mode, 'faucet-transaction-show') ) { return }

  if( $('.status').data('status') == 'pending' ) {
    setTimeout(
      function() { window.reload() },
      5000
    )
  }
} )
