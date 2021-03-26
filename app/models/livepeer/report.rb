class Livepeer::Report
  DEFAULT_VALUE = BigDecimal(0)

  def initialize(chain, params)
    @chain = chain
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
    Common::CsvExporter.new(data, self.class::FIELDS).call
  end

  private

  attr_reader :chain
  attr_reader :params
  attr_reader :range_type

  def summary_rows
    report_summary.data.each do |hash|
      hash[:round_number] = 'Summary'
    end
  end

  def details_rows
    details.map do |round_number, address|
      self.class::FIELDS.each_with_object({}) do |field, hash|
        hash[field] = field_value(field, round_number, address)
      end
    end
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

  def field_value(field_name, round_number, address)
    case field_name
    when :round_number then round_number
    when :delegator_address then address
    when :orchestrator_address then address
    else
      key = [round_number, address]
      send(field_name)[key] || self.class::DEFAULT_VALUE
    end
  end
end
