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
      order: [
        [2, 'desc'],
        [3, 'desc']
      ]
    });

    this.searchBox.keyup(() => this.search(this.table));

    this.radioButtons.forEach((radio) => {
      radio.addEventListener('change', () => this.filter(radio));
    });

    // Apply all default filters
    this.search(this.table);
  }
}

window.App.Avalanche.ValidatorTable = ValidatorTable;
