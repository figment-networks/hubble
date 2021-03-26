class Livepeer::OrchestratorPoolReportsController < Livepeer::ReportsController
  def show
    respond_to do |format|
      format.html do
        @report = Livepeer::PoolReportSummary.new(@chain, params)
        @orchestrators = @chain.orchestrators.to_a
      end

      format.csv do
        report = Livepeer::PoolReport.new(@chain, params)
        send_data(report.to_csv, filename: csv_filename)
      end
    end

    meta_description 'Total Stake and Reward Tokens'
  end

  private

  def csv_filename
    "orchestrator-pool-report-#{range}.csv"
  end
end
