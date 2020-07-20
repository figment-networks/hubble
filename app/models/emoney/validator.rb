class Emoney::Validator < ApplicationRecord
  include Cosmoslike::Validatorlike

  def current_commission
    rate = info_field( 'commission', 'commission_rates', 'rate' )
    rate ? rate.to_f : nil
  end

  def max_commission
    max = info_field( 'commission', 'commission_rates', 'max_rate' )
    max ? max.to_f : nil
  end

  def commission_change_rate
    rate = info_field( 'commission', 'commission_rates', 'max_change_rate' )
    rate ? rate.to_f : nil
  end

end
