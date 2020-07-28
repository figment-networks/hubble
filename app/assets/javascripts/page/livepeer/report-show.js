$(document).ready( function() {
  if( !_.includes(App.mode, 'report-show') ) { return }

  new App.Livepeer.ReportTable( $('.report-table') ).render()
} )
