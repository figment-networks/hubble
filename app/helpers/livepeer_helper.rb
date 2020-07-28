module LivepeerHelper
  def transcoder_link(transcoder)
    livepeer_explorer_link(transcoder.address, page: :campaign) do
      if transcoder.name.present?
        tag.strong(transcoder.name, title: transcoder.description)
      else
        transcoder.address.sub(/^0x/i, '').upcase
      end
    end
  end

  def delegator_link(address)
    livepeer_explorer_link(address, page: :staking) do
      address = address.sub(/^0x/i, '').upcase
      "#{address[0, 4]}...#{address[-4, 4]}"
    end
  end

  def livepeer_explorer_link(address, page: nil, &block)
    url = "https://explorer.livepeer.org/accounts/#{address}/#{page}"
    link_to(url, class: 'text-monospace', target: '_blank', &block)
  end

  def lpt_amount(value)
    amount_with_currency(value, 'LPT')
  end

  def eth_amount(value)
    amount_with_currency(value, 'ETH')
  end

  def amount_with_currency(value, currency_code)
    return if value.nil?

    safe_join([
      tag.span(number_to_human(value), class: 'text-monospace'),
      ' ',
      tag.span(currency_code, class: 'text-sm text-muted')
    ])
  end
end
