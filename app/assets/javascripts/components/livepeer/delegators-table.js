class DelegatorsTable {
  constructor(container) {
    this.container = container;
  }

  render() {
    this.table = this.container.find('table');
    const isEmpty = this.table.data('empty');
    console.log(isEmpty);

    this.table.DataTable({
      sDom: 'lrtip',
      paging: false,
      info: false,
      autoWidth: false,
      className: 'delegators-table',
      stripeClasses: isEmpty ? [] : ['even', 'odd'],
      order: isEmpty ? [] : [[1, 'desc']],
      columns: isEmpty ? [{width: '50%'}] : _.compact([
        {width: '50%'},
        {width: 'auto'},
        {width: 'auto'}
      ])
    });
  }
}

window.App.Livepeer.DelegatorsTable = DelegatorsTable;
