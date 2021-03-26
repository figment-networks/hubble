class ValidatorGroupsTable {
  constructor(container, skipColumns, emptyTableMessage = 'No validator groups data') {
    this.container = container;
    this.skipColumns = skipColumns || [];
    this.emptyTableMessage = emptyTableMessage;
    this.searchBox = $('.validator-groups-table-header .validator-groups-search');
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
      className: 'validator-groups-table',
      order: [[1, 'desc'], [3, 'desc']],
      language: {
        emptyTable: this.emptyTableMessage
      },
      columns: _.compact([
        _.includes(this.skipColumns, 'address') ? {visible: false} : {
          width: 'auto'
        },
        _.includes(this.skipColumns, 'votes') ? {visible: false} : {
          width: '250px'
        },
        _.includes(this.skipColumns, 'commission') ? {visible: false} : {
          width: '100px'
        },
        _.includes(this.skipColumns, 'uptime') ? {visible: false} : {
          width: '100px'
        },
        {visible: false}
      ])
    });


    this.searchBox.keyup(() => this.search(this.table));
  }
}

window.App.Celo.ValidatorGroupsTable = ValidatorGroupsTable;
