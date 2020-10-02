class Cosmoslike::GovernanceParamsDecorator
  ONE_DAY_IN_NANOSECONDS = (1.day.to_i * 1000 * 1000 * 1000).to_f

  def initialize(json)
    @payload = json
  end

  def quorum
    @payload['tally_params']['quorum'].to_f
  end

  def voting_period
    (new_param_layout? ?
      @payload['voting_params']['voting_period'] :
      @payload['voting_period']['voting_period']).to_f / ONE_DAY_IN_NANOSECONDS
  end

  def min_deposit_denom
    new_param_layout? ?
      @payload['deposit_params']['min_deposit'][0]['denom'] :
      @payload['deposit_period']['min_deposit'][0]['denom']
  end

  def min_deposit_amount
    (new_param_layout? ?
      @payload['deposit_params']['min_deposit'][0]['amount'] :
      @payload['deposit_period']['min_deposit'][0]['amount']).to_i
  end

  def max_deposit_period
    (new_param_layout? ?
      @payload['deposit_params']['max_deposit_period'] :
      @payload['deposit_period']['max_deposit_period']).to_f / ONE_DAY_IN_NANOSECONDS
  end

  def tally_param_threshold
    (new_param_layout? ?
      @payload['tally_params']['threshold'] :
      @payload['tallying_procedure']['threshold']).to_f
  end

  def tally_param_veto
    (new_param_layout? ?
      @payload['tally_params']['veto'] :
      @payload['tallying_procedure']['veto']).to_f
  end

  def tally_param_governance_penalty
    (new_param_layout? ?
      @payload['tally_params']['governance_penalty'] :
      @payload['tallying_procedure']['governance_penalty']).to_f
  end

  private

  def new_param_layout?
    !@payload.has_key?('tallying_procedure')
  end
end
