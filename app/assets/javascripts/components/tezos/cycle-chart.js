$(document).ready(function() {
  const el = $('#cycle-chart');

  if (el.length > 0) {
    const pct = el.data('percentage');

    const data = {
      datasets: [{
        data: [pct, 100 - pct],
        backgroundColor: ['#1a80f2', '#f1f1f1']
      }],
      labels: [
        'Complete',
        'Incomplete'
      ]
    };

    const chart = new Chart(el, {
      type: 'doughnut',
      data: data,
      options: {
        cutoutPercentage: 60,
        tooltips: {
          enabled: false
        },
        legend: {
          display: false
        }
      }
    });
  }
});
