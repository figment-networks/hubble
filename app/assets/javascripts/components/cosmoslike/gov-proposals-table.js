class GovProposalsTable {
  constructor(container) {
    this.container = container;
  }

  render() {
    this.table = this.container.find('table');
    const withValidator = this.table.data('withValidator');
    const isEmpty = this.table.data('empty');

    this.table.DataTable({
      'sDom': 'lrtip',
      'paging': false,
      'info': false,
      'autoWidth': false,
      'className': 'gov-proposals-table',
      'stripeClasses': isEmpty ? [] : ['even', 'odd'],
      'order': isEmpty ? [] : [[2, 'desc'], [1, 'desc']],
      'columns': isEmpty ? [{width: '45%'}] : _.compact([
        {
          width: '45%',
          className: 'col-title'
        },
        {
          width: 'auto',
          className: 'col-status'
        },
        (
          withValidator ?
            {width: 'auto', className: 'col-activity'} :
            {width: 'auto', className: 'col-time'}
        )
      ])
    });
  }
}

window.App.Cosmoslike.GovProposalsTable = GovProposalsTable;
