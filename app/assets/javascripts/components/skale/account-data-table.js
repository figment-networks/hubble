class AccountDataTable {
  constructor(container) {
    this.container = container;
  }

  render() {
    this.table = this.container.find('table').DataTable({
      sDom: 'lrtip',
      paging: false,
      autoWidth: false,
      className: 'account-data-table',
      order: [
        [2, 'desc'],
        [3, 'desc']
      ]
    });
  }
}

window.App.Skale.AccountDataTable = AccountDataTable;
