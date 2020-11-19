$(document).ready(function() {
  if (!_.includes(App.mode, 'chain-show')) {
    return;
  }

  new App.Cosmoslike.ValidatorTable($('.validator-table')).render();
  new App.Common.SmallAverageBlockTimeChart($('.average-block-time-chart')).render();
  new App.Cosmoslike.TinyAverageActiveValidatorsChart($('.average-active-validators-chart')).render();

  // 2 voting power charts
  const charts = {
    last48h: null,
    last30d: null
  };

  const switcherButtons = $('.validator-sparkline-switcher button');

  switcherButtons.click((e) => {
    e.preventDefault();
    const button = $(e.currentTarget);
    const target = button.data('target');
    $(`.small-average-voting-power-${target}-chart-container`).siblings().hide().end().show();
    charts[target] = charts[target] || new App.Cosmoslike.SmallAverageVotingPowerChart($(`.average-voting-power-${target}-chart`), target).render();
    button.siblings().removeClass('active').end().addClass('active');
  });
  switcherButtons.first().trigger('click');
});
