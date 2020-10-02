class DelegationsTable {
  constructor(container) {
    this.container = container;
  }

  render() {
    this.table = this.container.find('table');
    const isEmpty = this.table.data('empty');

    this.table.DataTable({
      'sDom': 'lrtip',
      'paging': false,
      'info': false,
      'autoWidth': false,
      'className': 'delegations-table',
      'stripeClasses': isEmpty ? [] : ['even', 'odd'],
      'order': isEmpty ? [] : [[2, 'desc'], [1, 'desc']],
      'columns': isEmpty ? [{width: '45%'}] : _.compact([
        {
          width: '45%',
          className: 'col-account'
        },
        {
          width: 'auto',
          className: 'col-amount'
        },
        {
          width: 'auto',
          className: 'col-status'
        }
      ])
    });
  }
}

window.App.Cosmoslike.DelegationsTable = DelegationsTable;
