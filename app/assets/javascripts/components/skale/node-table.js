class NodeTable {
  constructor(container, skipColumns) {
    this.container = container;
    this.skipColumns = skipColumns || [];
  }

  filter(radio) {
    const filter = radio.value;
    App.config.currentValidatorFilter = filter;
  }

  render() {
    this.table = this.container.find('table').DataTable({
      sDom: 'lrtip',
      info: false,
      paging: false,
      autoWidth: false,
      className: 'node-table',
      order: [
        [2, 'desc'],
        [3, 'desc']
      ]
    });
  }
}

window.App.Skale.NodeTable = NodeTable;
