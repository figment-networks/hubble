$(document).ready(function() {
  if (!_.includes(App.mode, 'chain-show')) {
    return;
  }

  new App.Avalanche.ValidatorTable($('.validator-table')).render();

  const switcherButtons = $('.delegations-stake-switcher button');
  const charts = {
    'last24h': null,
    'last30d': null,
    'validators': null,
    'delegations': null
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
      charts[target] = new App.Avalanche.ValidatorsStakeChart(chart, {scale: true}).render();
    }
  });

  switcherButtons.even().click();
});
