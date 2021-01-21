class ValidatorTable {
  constructor(container, skipColumns) {
    this.container = container;
    this.skipColumns = skipColumns || [];
    this.searchBox = $('.validator-table-header .validator-search');
  }

  search() {
    const term = this.searchBox.val();
    this.table.search(term).draw();
  }

  render() {
    this.table = this.container.find('table').DataTable({
      sDom: 'lrtip',
      paging: false,
      autoWidth: false,
      className: 'validator-table',
      order: [[0, 'asc'], [1, 'desc']],
      columns: _.compact([
        _.includes(this.skipColumns, 'address') ? {visible: false} : {
          width: 'auto'
        },
        _.includes(this.skipColumns, 'score') ? {visible: false} : {
          width: '100px'
        },
        {visible: false}
      ])
    });


    this.searchBox.keyup(() => this.search(this.table));
  }
}

window.App.Celo.ValidatorTable = ValidatorTable;
