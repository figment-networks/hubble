class ReportForm {
  constructor(container) {
    this.container = container;
  }

  render() {
    const rangeTypeGroup = this.container.find('.range-type-group');

    const roundRangeGroup = this.container.find('.round-range-group');
    const dateRangeGroup = this.container.find('.date-range-group');

    rangeTypeGroup.on('change', () => {
      const roundRangeRadio = this.container.find('#round-range');

      if (roundRangeRadio.is(':checked')) {
        this.hide(dateRangeGroup);
        this.show(roundRangeGroup);
      } else {
        this.hide(roundRangeGroup);
        this.show(dateRangeGroup);
      }
    });
  }

  hide(element) {
    element.addClass('d-none');
    element.prop('disabled', true);
  }

  show(element) {
    element.removeClass('d-none');
    element.prop('disabled', false);
  }
}

window.App.Livepeer.ReportForm = ReportForm;
