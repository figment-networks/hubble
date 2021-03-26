class Livepeer::DelegatorListReport < Livepeer::Report
  FIELDS = %i[
    round_number
    delegator_address
    fees
    reward_tokens
    pending_stake
    unclaimed_stake
    unbonding_tokens
    unbonded_tokens
  ].freeze

  def initialize(delegator_list, params)
    super(delegator_list.chain, params)

    @delegator_list = delegator_list
  end

  private

  attr_reader :delegator_list

  def report_summary
    Livepeer::DelegatorListReportSummary.new(delegator_list, params)
  end

  def details
    round_numbers.product(delegator_list.addresses)
  end

  def fees
    @fees ||= group_by_round_and_delegator(shares, :fees)
  end

  def reward_tokens
    @reward_tokens ||= group_by_round_and_delegator(shares, :reward_tokens)
  end

  def pending_stake
    @pending_stake ||= group_by_round_and_delegator(stakes, :pending_stake)
  end

  def unclaimed_stake
    @unclaimed_stake ||= group_by_round_and_delegator(stakes, :unclaimed_stake)
  end

  def unbonding_tokens
    @unbonding_tokens ||= group_by_round_and_delegator(unbondings, :unbonding_tokens)
  end

  def unbonded_tokens
    @unbonded_tokens ||= group_by_round_and_delegator(unbonds, :unbonded_tokens)
  end

  def group_by_round_and_delegator(records, field_name)
    records.each_with_object({}) do |record, hash|
      key = [record.round_number, record.delegator_address]
      hash[key] = record[field_name]
    end
  end

  def shares
    @shares ||= Livepeer::Queries::SharesPerRoundQuery.new(delegator_list, params).call
  end

  def stakes
    @stakes ||= Livepeer::Queries::StakesPerRoundQuery.new(delegator_list, params).call
  end

  def unbondings
    @unbondings ||= Livepeer::Queries::UnbondingsPerRoundQuery.new(delegator_list, params).call
  end

  def unbonds
    @unbonds ||= Livepeer::Queries::UnbondsPerRoundQuery.new(delegator_list, params).call
  end
end
