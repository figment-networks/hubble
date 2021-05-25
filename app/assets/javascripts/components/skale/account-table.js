class AccountTable {
  constructor(container) {
    this.container = container;
    this.searchBox = $('.account-search');
  }

  search() {
    const term = `${this.searchBox.val()}`;
    this.table.search(term).draw();
  }

  render() {
    this.table = this.container.find('table').DataTable({
      sDom: 'lrtip',
      paging: true,
      autoWidth: false,
      pageLength: 50,
      className: 'account-table'
    });

    this.searchBox.keyup(() => this.search(this.table));
    this.search(this.table);
  }
}

window.App.Skale.AccountTable = AccountTable;
