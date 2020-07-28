class Livepeer::ReportsController < Livepeer::BaseController
  before_action :require_user
  before_action :require_chain

  helper_method :report_params

  def new
    @round_numbers = @chain.rounds.order(number: :desc).pluck(:number)

    page_title 'Delegator List Report'
    meta_description 'Delegator List Report'
  end

  def show
    @delegator_list = delegator_lists.find(params[:delegator_list_id])
    @report = Livepeer::Report.new(@delegator_list, params)

    respond_to do |format|
      format.html
      format.csv do
        send_data(@report.to_csv, filename: csv_filename)
      end
    end

    page_title 'Delegator List Report'
    meta_description 'Fees, Rewards, Unbonding Tokens and Unbonded Tokens'
  end

  private

  def delegator_lists
    current_user.livepeer_delegator_lists.for(@chain)
  end

  def csv_filename
    case params[:range_type]
    when 'round'
      "report-#{params[:round_number]}.csv"
    when 'date'
      "report-#{params[:start_date]}-#{params[:end_date]}.csv"
    else
      "report.csv"
    end
  end

  def report_params
    params.permit(:range_type, :round_number, :start_date, :end_date)
  end
end
