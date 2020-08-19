$(document).ready( function() {
  if( !_.includes(App.mode, 'validator-show') ) { return }

  new App.Cosmoslike.ValidatorVotingPowerHistory( $('.voting-power-history-chart') ).render()
  new App.Cosmoslike.GovProposalsTable( $('.gov-proposals-table') ).render()
  new App.Cosmoslike.DelegationsTable( $('.delegations-table') ).render()
  document.querySelectorAll('.status-pie-chart').forEach(function(td) {
    new App.Cosmoslike.GovernanceProposalActivity(td).render();
  })
  
  
  new App.Cosmoslike.DelegationModal( $('#delegation-modal') )

  // 2 charts
  const charts = {
    last48h: null,
    alltime: null
  }

  new App.Cosmoslike.ValidatorUptimeHistory( $(`.uptime-history-last48h-chart`), 'last48h' ).render()

  // block heatmap
  const heatmap = $('.block-heatmap')
  const tooltipFn = window.customTooltip( { name: 'bhm', static: true, container: heatmap } )
  heatmap.find('.block').each( function() {
    const el = $(this)
    if( el.attr('title') ) {
      el.data('title', el.attr('title'))
      el.attr('title', null)
    }
  } ).hover(
    function( e ) {
      const blockEl = $(e.currentTarget)
      const tooltipEl = $(tooltipFn( {
        body: [ { lines: blockEl.data('title') } ]
      } ))
      blockEl.data( 'tooltip', tooltipEl )
    },
    function( e ) {
      const blockEl = $(e.currentTarget)
      const tooltipEl = blockEl.data('tooltip')
      blockEl.data('tooltip', null)
      if( tooltipEl ) { tooltipEl.remove() }
    }
  )
} )
