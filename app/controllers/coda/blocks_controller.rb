class Coda::BlocksController < Coda::BaseController
  def show
    @block        = details.block
    @transactions = details.transactions.sort_by(&:amount).reverse
    @snark_jobs   = details.snark_jobs
    @last_block   = client.current_block

    page_title 'Block'
    meta_description "Block #{@block.height}"
  end

  private

  def details
    @details ||= client.block(params[:id])
  end
end
