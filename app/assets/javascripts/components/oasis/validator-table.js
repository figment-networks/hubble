class ValidatorTable {
  constructor(container, skipColumns) {
    this.container = container;
    this.skipColumns = skipColumns || [];
    this.searchBox = $('.validator-table-header .validator-search');
    this.radioButtons = document.querySelectorAll('.validator-table-header .custom-radio input');
  }

  search() {
    const term = `${this.searchBox.val()} ${App.config.currentValidatorFilter}`;
    this.table.search(term).draw();
  }

  filter(radio) {
    const filter = radio.value;
    App.config.currentValidatorFilter = filter;
    this.search();
  }

  render() {
    this.table = this.container.find('table').DataTable({
      sDom: 'lrtip',
      paging: false,
      autoWidth: false,
      className: 'validator-table',
      order: [[1, 'desc'], [2, 'desc']],
      columns: _.compact([
        _.includes(this.skipColumns, 'address') ? null : {
          width: 'auto',
          className: 'col-address'
        },
        _.includes(this.skipColumns, 'voting') ? null : {
          width: '200px',
          className: 'col-voting'
        },
        _.includes(this.skipColumns, 'voting-percent') ? null : {
          width: '150px',
          className: 'col-voting-percent'
        },
        _.includes(this.skipColumns, 'uptime') ? null : {
          width: '75px',
          className: 'col-uptime'
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

window.App.Oasis.ValidatorTable = ValidatorTable;
