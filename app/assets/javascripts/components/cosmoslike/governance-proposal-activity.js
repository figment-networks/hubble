class GovernanceProposalActivity {
  constructor(target) {
    this.target = target;
  }

  render() {
    const ctx = this.target;

    const results = App.seed.GOVERNANCE_PROPOSAL_ACTIVITY[this.target.id];
    Chart.defaults.global.legend.display = false;

    const colors = ['#4BAE0A', '#6c757d', '#DC3545', '#921925'];
    const sum = results.reduce((acc, current) => acc + current);
    const highestResult = Math.max(...results);
    const highestResultIndex = results.indexOf(highestResult);
    const percentage = (highestResult * 100 / sum).toFixed() + '%';

    new Chart(ctx, {
      type: 'pie',
      data: {
        datasets: [{
          backgroundColor: colors,
          data: results
        }]
      },
      options: {
        responsive: false,
        maintainAspectRatio: false,
        tooltips: {
          enabled: false
        }
      }
    });
    const span = document.createElement('span');
    span.textContent = percentage;
    span.style.color = colors[highestResultIndex];
    ctx.after(span);
  }
}

window.App.Cosmoslike.GovernanceProposalActivity = GovernanceProposalActivity;
