$(document).ready(function() {
  if (!_.includes(App.mode, 'validator-show')) {
    return;
  }

  new App.Common.BlocksHeatmap($('.validator-blocks-heatmap')).render();
  new App.Mina.ValidatorBalanceChart($('.validator-balance-chart')).render();

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
      charts[target] = new App.Mina.ValidatorBlockChart(chart).render();
    }
  });

  switcherButtons.first().click();
});
