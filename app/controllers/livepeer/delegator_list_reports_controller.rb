class Livepeer::DelegatorListReportsController < Livepeer::ReportsController
  before_action :require_user

  def show
    @delegator_list = delegator_lists.find(params[:delegator_list_id])

    respond_to do |format|
      format.html do
        @report = Livepeer::DelegatorListReportSummary.new(@delegator_list, params)
      end

      format.csv do
        report = Livepeer::DelegatorListReport.new(@delegator_list, params)
        send_data(report.to_csv, filename: csv_filename)
      end
    end

    meta_description 'Fees, Rewards, Pending Stake, Unclaimed Stake, Unbonding Tokens and Unbonded Tokens'
  end

  private

  def delegator_lists
    current_user.livepeer_delegator_lists.for(@chain)
  end

  def csv_filename
    name = @delegator_list.name.parameterize
    "delegator-list-report-#{name}-#{range}.csv"
  end
end
