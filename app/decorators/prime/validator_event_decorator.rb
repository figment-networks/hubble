class Prime::ValidatorEventDecorator < SimpleDelegator
  include ActionView::Helpers::NumberHelper

  delegate :network, to: :chain

  def class_type
    to_model.class.name.split('::').last
  end

  def type_display
    class_type.underscore.humanize.titleize
  end

  def decorated_time
    time.strftime('%B %-d, %Y')
  end

  def display_voting_power_delta
    delta / (10 ** chain.reward_token_factor)
  end

  def description
    case class_type
    when 'ActiveSetInclusion'
      if positive?
        'Figment was added to the active set'
      else
        'Figment was removed from the active set'
      end
    when 'VotingPowerChange'
      if positive?
        "Figment voting power increased #{number_with_delimiter(display_voting_power_delta.round(2))} #{network.primary.reward_token_display}"
      else
        "Figment voting power decreased #{number_with_delimiter(display_voting_power_delta.abs.round(2))} #{network.primary.reward_token_display}"
      end
    when 'NConsecutive'
      "Figment missed #{n} consecutive blocks"
    when 'NOfM'
      "Figment missed #{n} of the last #{m} blocks"
    when 'RewardCutChange'
      "Figment validator commission changed to #{number_to_percentage(to, precision: 2)}"
    when 'DelegationChange'
      if positive?
        "#{delegators.count} accounts delegated to Figment"
      else
        "#{delegators.count} accounts undelegated from Figment"
      end
    end
  end
end
