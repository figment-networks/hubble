class ReportTable {
  constructor( container ) {
    this.container = container
  }

  render() {
    const table = this.container.find('table')

    this.table = table.DataTable( {
      sDom: 'lrtip',
      paging: false,
      info: false,
      autoWidth: false,
      className: 'report-table',
      stripeClasses: ['even', 'odd'],
      columns: _.compact( [
        { visible: false },
        { width: 'auto' },
        { width: '100px' },
        { width: '100px' },
        { width: '100px' },
        { width: '100px' },
        { width: '100px' },
        { width: '100px' }
      ] )
    } )
  }
}

window.App.Livepeer.ReportTable = ReportTable
