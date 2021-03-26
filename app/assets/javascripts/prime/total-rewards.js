(function() {
  const options = {
    series: [
      {
        name: 'Atom',
        data: [10, 41, 35, 51, 49, 62, 69, 91, 100, 70, 65, 90]
      }
    ],
    chart: {
      height: 350,
      type: 'line',
      zoom: {
        enabled: false
      }
    },
    legend: {
      show: false
    },
    dataLabels: {
      enabled: false
    },
    stroke: {
      curve: 'smooth',
      width: 2
    },
    colors: ['#111'],
    title: {
      text: 'Rewards % per network over time',
      align: 'center'
    },
    grid: {
      row: {
        colors: ['#fff', 'transparent'] // takes an array which will be repeated on columns
      }
    },
    xaxis: {
      categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    }
  };

  const chart = new ApexCharts(document.querySelector('#total-rewards-chart'), options);
  chart.render();
})();
