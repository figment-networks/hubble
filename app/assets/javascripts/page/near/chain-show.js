$(document).ready(function() {
  if (!_.includes(App.mode, 'chain-show')) {
    return;
  }

  new App.Near.ValidatorTable($('.validator-table')).render();
  new App.Cosmoslike.TinyAverageActiveValidatorsChart($('.average-active-validators-chart')).render();

  const switcherButtons = $('.block-time-switcher button');
  const charts = {
    'last48h': null,
    'last30d': null
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
      charts[target] = new App.Near.AverageBlockTimeChart(chart).render();
    }
  });

  switcherButtons.first().click();
});
