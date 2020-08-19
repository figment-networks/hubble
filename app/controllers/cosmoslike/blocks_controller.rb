class Cosmoslike::BlocksController < Cosmoslike::BaseController

  def show
    @block = @chain.blocks.find_by( height: params[:id] ) ||
             (@namespace::Block.stub_from_cache( @chain, params[:id] ) rescue nil)

    raise ActiveRecord::RecordNotFound if @block.nil?

    page_title @chain.network_name, @chain.name, "Transactions and Validators for block #{@block.height}"
    meta_description "#{@chain.network_name} -- #{@chain.name} - Transactions, Validators and Voting Power"

    respond_to do |format|
      format.html
      format.json do
        begin
          case params[:kind]
          when 'commit'
            render json: @chain.namespace::SyncBase.new(@chain).get_commit( @block.height )
          when 'block'
            render json: @chain.namespace::SyncBase.new(@chain).get_block( @block.height )
          when 'set'
            render json: @block.validator_set
          else
            render json: { error: "Unknown json #{params[:kind].inspect}." }
          end
        rescue
          render json: { error: 'Internal Server Error', status: 500 }
        end
      end
    end
  end
end
