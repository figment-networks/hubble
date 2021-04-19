module CeloHelper
  def celo_block_heatmap_title(sequence)
    span_arrow = tag.span('', class: 'fas fa-arrow-right text-sm text-muted mx-2')

    signed = sequence['signed']
    span_badge = tag.span(class: "badge badge-#{signed ? 'success' : 'danger'}") do
      signed ? 'OK' : 'MISSED'
    end

    "Block #{sequence['height']} #{span_arrow} #{span_badge}".html_safe
  end
end
