class Livepeer::Queries::ReportQuery
  def initialize(chain, params = {})
    @chain = chain
    @range_type = params[:range_type]&.to_sym
    @round_number = params[:round_number]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  end

  def call
    raise NotImplementedError
  end

  private

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
end
