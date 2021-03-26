class Prime::RewardsController < Prime::ApplicationController
  helper_method :report_params

  def index
    respond_to do |format|
      format.html do
        @new_account = Prime::Account.new
      end

      format.csv do
        network = Prime::Network.find_by(name: report_params[:network])
        report = Prime::DailyRewardsReport.new(current_user, network)
        send_data(report.to_csv, filename: csv_filename)
      end
    end
  end

  private

  def report_params
    params.permit(:network)
  end

  def csv_filename
    "prime-#{params[:network]}-daily-rewards-report.csv"
  end
end
