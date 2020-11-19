module FormattingHelper
  include ActionView::Helpers::NumberHelper

  def format_amount(amount, chain = nil, denom: nil, thousands_delimiter: true, hide_units: false, html: true, precision: 3, in_millions: false)
    chain ||= @chain
    denom ||= chain.token_map[chain.primary_token]

    # first account for the scaling factor on this chain
    if denom == 'gas'
      # gas should not be scaled
      denom = 'GAS'
    elsif denom.in?(chain.token_map.keys)
      amount /= 10 ** chain.token_map[denom]['factor'].to_f
      denom = chain.token_map[denom]['display']
    end

    # 'amount' here can be huge, so let's decide on a denomination to display
    val, scale = if amount >= MEGA && in_millions then [(amount / MEGA), 'M']
                 elsif amount >= GIGA then [(amount / KILO), 'k']
                 else [amount, '']
                 end

    num_str = "#{number_with_delimiter(round_if_whole(val, precision))}#{scale}"
    denom_str = hide_units ? '' : denom
    if html
      num_str = "<span class='text-monospace'>#{num_str}</span>"
      denom_str = "<span class='text-sm text-muted sup'>#{denom_str}</span>" if denom_str.present?
    end

    "#{num_str} #{denom_str}".strip.html_safe
  end

  def round_if_whole(num, precision = 3)
    return 0 if num.blank? || num.zero? || num.to_f.nan? || num.to_f.infinite?

    if precision == 0
      return num.round.floor
    end

    if num <= 0.0001
      # force printing with precision instead of scientific notation
      # and then strip off trailing 0s
      return 0 if num.round(5).zero?

      return ('%.5f' % num).sub(/0*$/, '')
    end

    tries = 10
    while tries > 0
      rounded = num.round(precision)
      break if rounded != 0

      precision += 1
      tries -= 1
    end

    rounded.to_f.floor == rounded ? rounded.round(0).floor : rounded
  end

  def round_if_whole_with_delim(num, precision = 3)
    num = 0 if num.blank? || num.to_f.nan? || num.to_f.infinite?
    number_with_delimiter round_if_whole(num, precision)
  end

  def format_timestamp(timestamp)
    timestamp.strftime('%Y-%m-%d @ %H:%M %Z')
  end

  def rounded_percentage(amount)
    return format('%.2f', 0) if amount <= 0

    format('%.2f', amount)
  end
end
