$(document).ready(function() {
  if (!_.includes(App.mode, 'chain-show')) {
    return;
  }

  new App.Coda.ValidatorsTable($('.validator-table')).render();
  new App.Coda.ValidatorsChart($('.validators-chart')).render();
  new App.Coda.BlockTimesChart($('.average-block-time-chart')).render();

  const switcherButtons = $('.transactions-volume-switcher button');
  const charts = {
    'payments': null,
    'fees': null,
    'work-fees': null
  };

  switcherButtons.click((e) => {
    e.preventDefault();

    const button = $(e.currentTarget);
    const target = button.data('target');
    const container = $(`.${target}-chart-container`);
    const chart = $(`.${target}-chart`);

    button.siblings().removeClass('active').end().addClass('active');
    container.siblings().hide().end().show();

    if (!charts[target]) {
      charts[target] = new App.Coda.TransactionsVolumeChart(chart).render();
    }
  });

  switcherButtons.first().click();
});
