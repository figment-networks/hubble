class Near::BlocksController < Near::BaseController
  def show
    respond_to do |format|
      format.html do
        # events pages
        @current_events_page = params['events_page'].to_i || 1
        @events = client.paginate(Near::Event, '/events', { height: params[:id], page: @current_events_page, limit: 25 })

        # transactions_pages
        @current_transactions_page = params['transactions_page'].to_i || 1
        @transactions = client.paginate(Near::Transaction, '/transactions', { block_height: params[:id], page: @current_transactions_page, limit: 25 })

        # page data
        @block = client.block(params[:id])
        @last_block = client.current_block

        raise ActiveRecord::RecordNotFound unless @block

        page_title "Block #{@block.id}"
        meta_description "Block #{@block.id}"
      end
      format.json do
        render json: { block: client.block(params[:id].split('.')[0]) }
      end
    end
  end
end
