class Livepeer::ReportsController < Livepeer::BaseController
  before_action :require_user
  before_action :require_chain

  helper_method :round_range?
  helper_method :date_range?
  helper_method :report_params

  def new
    @round_numbers = @chain.rounds.order(number: :desc).pluck(:number)

    page_title 'Delegator List Report'
    meta_description 'Delegator List Report'
  end

  def show
    @delegator_list = delegator_lists.find(params[:delegator_list_id])

    respond_to do |format|
      format.html do
        @report = Livepeer::SummaryReport.new(@delegator_list, params)
      end

      format.csv do
        report = Livepeer::DetailedReport.new(@delegator_list, params)
        send_data(report.to_csv, filename: csv_filename)
      end
    end

    page_title 'Delegator List Report'
    meta_description 'Fees, Rewards, Pending Stake, Unclaimed Stake, Unbonding Tokens and Unbonded Tokens'
  end

  private

  def delegator_lists
    current_user.livepeer_delegator_lists.for(@chain)
  end

  def csv_filename
    name = @delegator_list.name.parameterize
    range =
      if round_range?
        params[:round_number]
      elsif date_range?
        "#{params[:start_date]}-#{params[:end_date]}"
      end

    "delegator-list-report-#{name}-#{range}.csv"
  end

  def round_range?
    params[:range_type] == 'round'
  end

  def date_range?
    params[:range_type] == 'date'
  end

  def report_params
    params.permit(:range_type, :round_number, :start_date, :end_date)
  end
end
