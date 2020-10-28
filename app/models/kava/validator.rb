class Kava::Validator < ApplicationRecord
  include Cosmoslike::Validatorlike

  scope :active, -> { where.not(current_voting_power: 0) }

  def current_commission
    return super if chain.sdk_lt?('0.36.0-rc1')

    rate = info_field('commission', 'commission_rates', 'rate')
    rate ? rate.to_f : nil
  end

  def max_commission
    return super if chain.sdk_lt?('0.36.0-rc1')

    max = info_field('commission', 'commission_rates', 'max_rate')
    max ? max.to_f : nil
  end

  def commission_change_rate
    return super if chain.sdk_lt?('0.36.0-rc1')

    rate = info_field('commission', 'commission_rates', 'max_change_rate')
    rate ? rate.to_f : nil
  end
end
