class Skale::NodesController < Skale::BaseController
  def show
    @node = client.node(id: params[:id])
    raise ActiveRecord::RecordNotFound unless @node

    @validator = client.validator(@node.validator_id)
    page_title 'Nodes'
    meta_description "Node #{@node.name}"
  end
end
