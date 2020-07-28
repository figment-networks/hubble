class DelegatorListsTable {
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
      className: 'delegator-lists-table',
      stripeClasses: ['even', 'odd'],
      language: {
        emptyTable: 'No delegator lists'
      },
      columns: _.compact( [
        { width: '50px' },
        { width: 'auto' },
        { width: '150px' },
        { width: '150px' },
        { width: '150px', orderable: false }
      ] )
    } )
  }
}

window.App.Livepeer.DelegatorListsTable = DelegatorListsTable
