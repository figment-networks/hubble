class Cosmos::ValidatorsController < Cosmoslike::ValidatorsController
  # Cosmoslike::ValidatorssController temporarily overrideen due to
  # delegations indexing issue - this method should just be
  # deleted once that problem is corrected.
  def show
    @validator = @chain.validators.find_by(address: params[:id])
    raise ActiveRecord::RecordNotFound unless @validator

    page_title @chain.network_name, @chain.name, @validator.name_and_owner, 'Voting Power and Event History'
    meta_description 'Voting History -- All changes, Uptime history -- Last 48 hours, Governance Proposals, Activity and Event History'

    respond_to do |format|
      format.html
      format.json do
        recent_blocks = @chain.blocks.limit(100)

        uptime = (recent_blocks.select { |b| b.precommitters.include?(@validator.address) }.count / 100.0).to_f
        proposals = recent_blocks.select { |b| b.proposer_address == @validator.address }.count

        render json: {
          moniker: @validator.moniker,
          url: namespaced_path('validator', @validator, full: true),
          voting_power: @validator.current_voting_power.to_i,
          commission: @validator.current_commission,
          recent_uptime: uptime,
          recent_proposals: proposals
        }
      end
    end
  end

  private

  def find_chain
    @namespace = self.class.name.split('::').first.constantize
    @chain = @namespace::Chain.alive.find_by!(slug: (params[:chain_id] || params[:id]).try(:downcase))
  end
end
