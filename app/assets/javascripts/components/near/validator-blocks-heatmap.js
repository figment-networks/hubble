class ValidatorBlocksHeatmap {
  constructor(target) {
    this.target = target
  }

  render() {
    const tooltipFn = window.customTooltip({ name: 'bhm', static: true, container: this.target })
    this.target.find('.block').each(function () {
      const el = $(this)
      if (el.attr('title')) {
        el.data('title', el.attr('title'))
        el.attr('title', null)
      }
    }).hover(
      function (e) {
        const blockEl = $(e.currentTarget)
        const tooltipEl = $(tooltipFn({
          body: [{ lines: blockEl.data('title') }]
        }))
        blockEl.data('tooltip', tooltipEl)
      },
      function (e) {
        const blockEl = $(e.currentTarget)
        const tooltipEl = blockEl.data('tooltip')
        blockEl.data('tooltip', null)
        if (tooltipEl) { tooltipEl.remove() }
      }
    )
  }
}

window.App.Near.ValidatorBlocksHeatmap = ValidatorBlocksHeatmap
