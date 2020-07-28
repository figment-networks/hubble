$(document).ready( function() {
  if( !_.includes(App.mode, 'report-new') ) { return }

  new App.Livepeer.ReportForm( $('.report-form') ).render()
} )
