class Livepeer::DetailedReport
  DEFAULT_VALUE = BigDecimal(0)

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
    @delegator_list = delegator_list
    @chain = delegator_list.chain
    @params = params
    @range_type = params[:range_type]&.to_sym
  end

  def data
    if range_type == :round
      details_rows
    else
      summary_rows + details_rows
    end
  end

  def to_csv
    Common::CsvExporter.new(data, FIELDS).call
  end

  private

  attr_reader :delegator_list
  attr_reader :chain
  attr_reader :params
  attr_reader :range_type

  def summary_rows
    summary_report.data.each do |hash|
      hash[:round_number] = 'Summary'
    end
  end

  def summary_report
    Livepeer::SummaryReport.new(delegator_list, params)
  end

  def details_rows
    details.map do |round_number, delegator_address|
      FIELDS.each_with_object({}) do |field, hash|
        hash[field] = field_value(field, round_number, delegator_address)
      end
    end
  end

  def details
    round_numbers.product(delegator_list.addresses)
  end

  def round_numbers
    rounds.order(:number).pluck(:number)
  end

  def rounds
    case range_type
    when :round
      chain.rounds.where(number: params[:round_number])
    when :date
      chain.rounds.where(<<~SQL, params[:start_date], params[:end_date])
        date(livepeer_rounds.initialized_at) BETWEEN ? AND ?
      SQL
    else
      chain.rounds
    end
  end

  def field_value(field_name, round_number, delegator_address)
    case field_name
    when :round_number then round_number
    when :delegator_address then delegator_address
    else
      key = [round_number, delegator_address]
      send(field_name)[key] || DEFAULT_VALUE
    end
  end

  def fees
    group_by_round_and_delegator(shares, :fees)
  end

  def reward_tokens
    group_by_round_and_delegator(shares, :reward_tokens)
  end

  def pending_stake
    group_by_round_and_delegator(stakes, :pending_stake)
  end

  def unclaimed_stake
    group_by_round_and_delegator(stakes, :unclaimed_stake)
  end

  def unbonding_tokens
    group_by_round_and_delegator(unbondings, :unbonding_tokens)
  end

  def unbonded_tokens
    group_by_round_and_delegator(unbonds, :unbonded_tokens)
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
