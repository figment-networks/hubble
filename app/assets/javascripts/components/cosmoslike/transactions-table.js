class TransactionsTable {
  constructor(container) {
    this.container = container;
  }

  render() {
    const table = this.container.find('table');
    const isEmpty = table.data('empty');
    this.table = table.DataTable({
      'sDom': 'lrtip',
      'paging': false,
      'info': false,
      'autoWidth': false,
      'className': 'transactions-table',
      'stripeClasses': isEmpty ? [] : ['even', 'odd'],
      'order': isEmpty ? [] : [[1, 'desc'], [2, 'desc']],
      'columns': isEmpty ? [{width: '45%'}] : _.compact([
        {
          width: 'auto',
          className: 'col-hash'
        },
        {
          width: '150px',
          className: 'col-fee'
        },
        {
          width: '150px',
          className: 'col-gas'
        },
        {
          width: '150px',
          className: 'col-status'
        },
        {
          width: '150px',
          className: 'col-buttons',
          orderable: false
        }
      ])
    });
  }
}

window.App.Cosmoslike.TransactionsTable = TransactionsTable;
