require 'csv'

class Oasis::CsvReportDecorator
  include FormattingHelper

  def initialize(table)
    @table = table
  end

  def generate_csv_data
    @table.css('tr').map do |r|
      r.css('td,th').map(&:text).to_csv
    end.join
  end
end
