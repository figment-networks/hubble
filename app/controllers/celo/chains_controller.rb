class Celo::ChainsController < Celo::BaseController
  def show
    status = client.status
    @height = status.last_indexed_height
    @last_block_time = status.last_block_time
    @validator_groups = client.validator_groups(@height)
    validator_groups_summary = client.validator_groups_summary
    @validator_groups_summary = validator_groups_summary.map do |summary|
      Common::SummaryChartDecorator.new(summary).point(@chain)
    end
    @current_groups_summary_total = validator_groups_summary.last.try(:total)

    raw_block_summary = client.blocks_summary
    @blocks_summary = raw_block_summary.map do |summary|
      Common::ChartDecorator.new(summary).point
    end
    @average_block_time = raw_block_summary.map(&:block_time_avg).sum / raw_block_summary.size.to_f

    page_title 'Overview'
    meta_description 'Validator groups'
  end

  def search
    flash[:warning] = 'Sorry, search on this network is currently unavailable!'
    redirect_to celo_chain_path(@chain)
  end
end
