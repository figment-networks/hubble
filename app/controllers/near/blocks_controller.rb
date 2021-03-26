class Near::BlocksController < Near::BaseController
  def show
    @block = client.block(params[:id])
    @last_block = client.current_block

    respond_to do |format|
      format.html do
        raise ActiveRecord::RecordNotFound unless @block

        page_title 'Block'
        meta_description "Block #{@block.id}"
      end
      format.json do
        render json: { block: client.block(params[:id].split('.')[0]) }
      end
    end
  end
end
