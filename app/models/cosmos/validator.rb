class Cosmos::Validator < ApplicationRecord
  include Cosmoslike::Validatorlike

  def current_commission
    return super if chain.sdk_lt?('0.36.0')

    if chain.sdk_gte?('0.36.0')
      rate = info_field('commission', 'commission_rates', 'rate')
    else
      rate = info_field('commission', 'CommissionRates', 'rate')
    end
    rate ? rate.to_f : nil
  end

  def max_commission
    return super if chain.sdk_lt?('0.36.0')

    if chain.sdk_gte?('0.36.0')
      max = info_field('commission', 'commission_rates', 'max_rate')
    else
      max = info_field('commission', 'CommissionRates', 'max_rate')
    end
    max ? max.to_f : nil
  end

  def commission_change_rate
    return super if chain.sdk_lt?('0.36.0')

    if chain.sdk_gte?('0.36.0')
      rate = info_field('commission', 'commission_rates', 'max_change_rate')
    else
      rate = info_field('commission', 'CommissionRates', 'max_change_rate')
    end
    rate ? rate.to_f : nil
  end
end
