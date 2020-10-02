class ValidatorTable {
  constructor(container, skipColumns) {
    this.container = container;
    this.skipColumns = skipColumns || [];
    this.searchBox = $('.validator-table-header .validator-search');
  }

  search() {
    const term = `${this.searchBox.val()} ${App.config.currentValidatorFilter}`;
    this.table.search(term).draw();
  }

  settingsPopoverContent() {
    const generateContent = (button) => {
      const contentEl = $(button).siblings('.validator-table-settings');
      const html = $(contentEl.html());
      return html
          .find('button').click((e) => {
            const button = $(e.currentTarget);
            const target = button.data('target');
            App.config.currentValidatorFilter = target;
            button.addClass('active').siblings().removeClass('active');
            this.search();
          })
          .end()
          .find(`button[data-target=${App.config.currentValidatorFilter}]`)
          .addClass('active')
          .end();
    };
    return function() {
      return generateContent(this);
    };
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
        _.includes(this.skipColumns, 'uptime') ? null : {
          width: '150px',
          className: 'col-uptime'
        },
        {visible: false}
      ])
    });

    this.searchBox.keyup(() => this.search(this.table));

    $('.validator-table-header .validator-table-settings-target').popover({
      html: true,
      placement: 'bottom',
      offset: '-40%p',
      content: this.settingsPopoverContent()
    });
  }
}

window.App.Cosmoslike.ValidatorTable = ValidatorTable;
