class Livepeer::Queries::ReportQuery
  def initialize(delegator_list, params)
    @delegator_list = delegator_list
    @chain = delegator_list.chain
    @range_type = params[:range_type]&.to_sym
    @round_number = params[:round_number]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  end

  def call
    raise NotImplementedError
  end

  private

  attr_reader :delegator_list
  attr_reader :chain
  attr_reader :range_type
  attr_reader :round_number
  attr_reader :start_date
  attr_reader :end_date

  def filter_by_range(relation)
    case range_type
    when :round
      filter_by_round(relation)
    when :date
      filter_by_date(relation)
    else
      relation
    end
  end

  def filter_by_round(relation)
    relation.where(livepeer_rounds: { number: round_number })
  end

  def filter_by_date(relation)
    relation.where(<<~SQL, start_date, end_date)
      date(livepeer_rounds.initialized_at) BETWEEN ? AND ?
    SQL
  end

  def filter_by_delegators(relation)
    relation.where(delegator_address: delegator_list.addresses)
  end

  def group_by_delegator(relation)
    relation.group(:delegator_address).select(self.class::FIELDS)
  end

  def group_by_round_and_delegator(relation)
    relation.
      group(:round_number, :delegator_address).
      select(self.class::FIELDS).
      order(:round_number)
  end
end
