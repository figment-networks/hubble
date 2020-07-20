$(document).ready(function() {
  var el = $("#cycle-chart")

  if (el.length > 0) {
    var pct = el.data("percentage")

    var data = {
      datasets: [{
        data: [pct, 100 - pct],
        backgroundColor: ["#1a80f2", "#f1f1f1"]
      }],
      labels: [
        'Complete',
        'Incomplete'
      ]
    }

    var chart = new Chart(el, {
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
    })
  }
})
