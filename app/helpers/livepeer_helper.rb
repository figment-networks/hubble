module LivepeerHelper
  def livepeer_address(value, short: false)
    address = value.sub(/^0x/i, '').upcase
    short ? "#{address[0, 4]}...#{address[-4, 4]}" : address
  end

  def livepeer_explorer_link(address, page: nil, short: false)
    url = "https://explorer.livepeer.org/accounts/#{address}/#{page}"

    link_to(url, class: 'text-monospace', target: '_blank') do
      livepeer_address(address, short: short)
    end
  end

  def livepeer_lpt_amount(value)
    livepeer_amount(value, 'LPT')
  end

  def livepeer_eth_amount(value)
    livepeer_amount(value, 'ETH')
  end

  def livepeer_amount(value, currency)
    return if value.nil?

    safe_join([
      tag.span(number_to_human(value), class: 'text-monospace'),
      tag.span(" #{currency}", class: 'text-sm text-muted')
    ])
  end

  def livepeer_event_kind_to_type(kind)
    "Livepeer::Events::#{kind.classify}"
  end
end
