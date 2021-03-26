class Prime::FailedNetworkEventDecorator < SimpleDelegator
  def display_date
    '-'
  end

  def title
    '-'
  end

  def source
    ''
  end
end
