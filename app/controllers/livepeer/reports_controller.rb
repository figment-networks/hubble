class Livepeer::ReportsController < Livepeer::BaseController
  before_action :require_chain

  before_action :set_default_page_title
  before_action :set_default_meta_description

  helper_method :round_range?
  helper_method :date_range?
  helper_method :report_params

  def new
    @round_numbers = @chain.rounds.order(number: :desc).pluck(:number)
  end

  private

  def round_range?
    params[:range_type] == 'round'
  end

  def date_range?
    params[:range_type] == 'date'
  end

  def range
    if round_range?
      params[:round_number]
    elsif date_range?
      "#{params[:start_date]}-#{params[:end_date]}"
    end
  end

  def report_params
    params.permit(:range_type, :round_number, :start_date, :end_date)
  end
end
