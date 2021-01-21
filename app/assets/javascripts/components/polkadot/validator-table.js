// TODO: refactor, what's different between this and other ValidatorTables is only order and columns in render method
class ValidatorTable {
  constructor(container, skipColumns) {
    this.container = container;
    this.skipColumns = skipColumns || [];
    this.searchBox = $('.validator-table-header .validator-search');
    this.radioButtons = document.querySelectorAll('.validator-table-header .custom-radio input');
  }

  filter(radio) {
    const filter = radio.value;
    App.config.currentValidatorFilter = filter;
    this.search();
  }

  search() {
    const term = `${this.searchBox.val()} ${App.config.currentValidatorFilter}`;
    this.table.search(term).draw();
  }

  render() {
    this.table = this.container.find('table').DataTable({
      sDom: 'lrtip',
      paging: false,
      autoWidth: false,
      className: 'validator-table',
      order: [[3, 'desc'], [1, 'desc']],
      columns: _.compact([
        _.includes(this.skipColumns, 'address') ? {visible: false} : {
          width: 'auto'
        },
        _.includes(this.skipColumns, 'total_stake') ? {visible: false} : {
          width: '250px'
        },
        _.includes(this.skipColumns, 'commission') ? {visible: false} : {
          width: '150px'
        },
        _.includes(this.skipColumns, 'uptime') ? {visible: false} : {
          width: '100px'
        },
        _.includes(this.skipColumns, 'state') ? {visible: false} : {
          width: '100px'
        },
        {visible: false}
      ])
    });

    this.searchBox.keyup(() => this.search(this.table));
    this.radioButtons.forEach((radio) => {
      radio.addEventListener('change', () => this.filter(radio));
    });
  }
}

window.App.Polkadot.ValidatorTable = ValidatorTable;
