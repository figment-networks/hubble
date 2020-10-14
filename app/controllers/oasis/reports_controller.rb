class Oasis::ReportsController < Oasis::BaseController
  def new
    page_title @chain.network_name, @chain.name, 'Rewards'
    meta_description "#{@chain.network_name} -- #{@chain.name} rewards and commission reporting"
  end

  def create
    redirect_to oasis_chain_report_path(@chain, params[:id])
  end

  def show
    @rewards = @chain.client.rewards(params[:id])
    # Indexer currently returns empty array if invalid address is sent in request
    raise Common::IndexerClient::Error, 'No validator or account found.' if @rewards&.empty?

    @rewards = @rewards.sort_by(&:escrow_address).reverse.sort_by(&:time_bucket).reverse

    respond_to do |format|
      format.html do
        page_title @chain.network_name, @chain.name, params['id'], 'Rewards'
        meta_description "#{@chain.network_name} -- #{@chain.name} rewards and commission reporting for #{params['id']}"
      end
      format.csv do
        content = render_to_string(action: 'show.html.erb', address: params[:id])
        table = Nokogiri::HTML(content).at_css('table')
        csv = Oasis::CsvReportDecorator.new(table)
        send_data(csv.generate_csv_data, type: 'text/csv', filename: csv_filename)
      end
    end
  rescue Common::IndexerClient::Error => error
    @rewards = Oasis::RewardsReport.failed(params[:id])
    @error = error
  end

  private

  def csv_filename
    "#{Time.now.strftime('%Y-%m-%d')}-#{@chain.slug}-#{params[:id]}.csv"
  end
end
