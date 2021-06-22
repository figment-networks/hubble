class ValidatorDelegationsTable {
  constructor(container) {
    this.container = container;
    this.searchBox = $('.validator-delegations-search');
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
      pageLength: 10,
      pagingType: 'simple',
      className: 'validator-delegations-table'
    });

    this.searchBox.keyup(() => this.search(this.table));
    this.search(this.table);
  }
}

window.App.Skale.ValidatorDelegationsTable = ValidatorDelegationsTable;
