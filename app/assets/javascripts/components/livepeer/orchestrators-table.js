class OrchestratorsTable {
  constructor(container, skipColumns) {
    this.container = container;
    this.skipColumns = skipColumns || [];
    this.searchBox = $('.orchestrators-table-header .orchestrators-search');
    this.radioButtons = document.querySelectorAll('.orchestrators-table-header .custom-radio input');
  }

  filter(radio) {
    const filter = radio.value;
    App.config.currentOrchestratorsFilter = filter;
    this.search();
  }

  search() {
    const term = `${this.searchBox.val()} ${App.config.currentOrchestratorsFilter}`;
    this.table.search(term).draw();
  }

  render() {
    this.table = this.container.find('table').DataTable({
      sDom: 'lrtip',
      paging: false,
      autoWidth: false,
      className: 'orchestrators-table',
      order: [[2, 'desc']],
      language: {
        emptyTable: 'No orchestrators available'
      },
      columns: _.compact([
        {width: 'auto'},
        {width: '150px'},
        {width: '150px'},
        {visible: false}
      ])
    });

    this.searchBox.keyup(() => this.search(this.table));
    this.radioButtons.forEach((radio) => {
      radio.addEventListener('change', () => this.filter(radio));
    });
  }
}

window.App.Livepeer.OrchestratorsTable = OrchestratorsTable;
