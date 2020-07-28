class Livepeer::Report
  FIELDS = %i[
    delegator_address
    fees
    reward_tokens
    pending_stake
    unclaimed_stake
    unbonding_tokens
    unbonded_tokens
  ].freeze

  def initialize(delegator_list, params)
    @delegator_list = delegator_list
    @params = params
  end

  def data
    @delegator_list.addresses.map do |address|
      FIELDS.each_with_object({}) do |field, hash|
        hash[field] = send(field)[address] || 0.to_d
      end
    end
  end

  def to_csv
    Common::CsvExporter.new(data, FIELDS).call
  end

  private

  attr_reader :delegator_list
  attr_reader :params

  def delegator_address
    ->(address) { address }
  end

  def fees
    group_by_delegator(shares, :fees)
  end

  def reward_tokens
    group_by_delegator(shares, :reward_tokens)
  end

  def pending_stake
    group_by_delegator(stakes, :pending_stake)
  end

  def unclaimed_stake
    group_by_delegator(stakes, :unclaimed_stake)
  end

  def unbonding_tokens
    group_by_delegator(unbondings, :unbonding_tokens)
  end

  def unbonded_tokens
    group_by_delegator(unbonds, :unbonded_tokens)
  end

  def group_by_delegator(records, field_name)
    records.each_with_object({}) do |record, hash|
      hash[record.delegator_address] = record[field_name]
    end
  end

  def shares
    @shares ||= Livepeer::Queries::SharesQuery.new(delegator_list, params).call
  end

  def stakes
    @stakes ||= Livepeer::Queries::StakesQuery.new(delegator_list, params).call
  end

  def unbondings
    @unbondings ||= Livepeer::Queries::UnbondingsQuery.new(delegator_list, params).call
  end

  def unbonds
    @unbonds ||= Livepeer::Queries::UnbondsQuery.new(delegator_list, params).call
  end
end
