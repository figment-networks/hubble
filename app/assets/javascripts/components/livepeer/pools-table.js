class PoolsTable {
  constructor(container) {
    this.container = container;
  }

  render() {
    const table = this.container.find('table');

    this.table = table.DataTable({
      sDom: 'lrtip',
      paging: false,
      info: false,
      autoWidth: false,
      className: 'pools-table',
      stripeClasses: ['even', 'odd'],
      order: [[1, 'desc'], [2, 'desc']],
      language: {
        emptyTable: 'No pools available'
      },
      columns: _.compact([
        {width: 'auto'},
        {width: '150px'},
        {width: '150px'}
      ])
    });
  }
}

window.App.Livepeer.PoolsTable = PoolsTable;
