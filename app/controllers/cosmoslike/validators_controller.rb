class Cosmoslike::ValidatorsController < Cosmoslike::BaseController

  def show
    @validator = @chain.validators.find_by( address: params[:id] )
    raise ActiveRecord::RecordNotFound unless @validator

    page_title @chain.network_name, @chain.name, @validator.name_and_owner, 'Voting Power and Event History'
    meta_description "Voting History -- All changes, Uptime history -- Last 48 hours, Governance Proposals, Activity and Event History"

    respond_to do |format|
      format.html
      format.json {
        recent_blocks = @chain.blocks.limit( 100 )

        uptime = (recent_blocks.select { |b| b.precommitters.include?(@validator.address) }.count / 100.0).to_f
        proposals = recent_blocks.select { |b| b.proposer_address == @validator.address }.count

        delegations = @chain.namespace::ValidatorDelegationsDecorator.new(@chain, @validator).delegations.count

        render json: {
          moniker: @validator.moniker,
          url: namespaced_path( 'validator', @validator, full: true ),
          voting_power: @validator.current_voting_power.to_i,
          commission: @validator.current_commission,
          recent_uptime: uptime,
          recent_proposals: proposals,
          delegations: delegations
        }
      }
    end
  end

end
