class Prime::NetworkEventDecorator < SimpleDelegator
  def decorated_date
    update_date.strftime('%B %-d, %Y')
  end
end
