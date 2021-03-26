class PoolReportTable {
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
      className: 'report-table',
      order: [[2, 'desc']],
      stripeClasses: ['even', 'odd'],
      columns: _.compact([
        {visible: false},
        {width: 'auto'},
        {width: '200px'},
        {width: '200px'}
      ])
    });
  }
}

window.App.Livepeer.PoolReportTable = PoolReportTable;
