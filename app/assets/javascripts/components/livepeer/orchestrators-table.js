class OrchestratorsTable {
  constructor(container, skipColumns) {
    this.container = container;
    this.skipColumns = skipColumns || [];
    this.searchBox = $('.orchestrators-table-header .orchestrators-search');
  }

  search() {
    const term = `${this.searchBox.val()} ${App.config.currentOrchestratorsFilter}`;
    this.table.search(term).draw();
  }

  settingsPopoverContent() {
    const generateContent = (button) => {
      const contentEl = $(button).siblings('.orchestrators-table-settings');
      const html = $(contentEl.html());
      return html
          .find('button').click((e) => {
            const button = $(e.currentTarget);
            const target = button.data('target');
            App.config.currentOrchestratorsFilter = target;
            button.addClass('active').siblings().removeClass('active');
            this.search();
          })
          .end()
          .find(`button[data-target=${App.config.currentOrchestratorsFilter}]`)
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

    $('.orchestrators-table-header .orchestrators-table-settings-target').popover({
      html: true,
      placement: 'bottom',
      offset: '-40%p',
      content: this.settingsPopoverContent()
    });
  }
}

window.App.Livepeer.OrchestratorsTable = OrchestratorsTable;
