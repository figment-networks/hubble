class ValidatorEpochsTable {
  constructor(container) {
    this.container = container
  }

  render() {
    this.table = this.container.find('table').DataTable({
      sDom: 'lrtip',
      paging: false,
      autoWidth: false,
      className: 'table',
      stripeClasses: ['even', 'odd'],
      language: {
        emptyTable: 'No epochs found'
      },
      order: [
        [0, 'asc']
      ],
    })
  }
}

window.App.Near.ValidatorEpochsTable = ValidatorEpochsTable
