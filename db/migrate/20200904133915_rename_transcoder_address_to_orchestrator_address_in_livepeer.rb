class RenameTranscoderAddressToOrchestratorAddressInLivepeer < ActiveRecord::Migration[5.2]
  def change
    rename_column :livepeer_delegators, :transcoder_address, :orchestrator_address
    rename_column :livepeer_pools, :transcoder_address, :orchestrator_address
    rename_column :livepeer_bonds, :transcoder_address, :orchestrator_address
    rename_column :livepeer_unbonds, :transcoder_address, :orchestrator_address
    rename_column :livepeer_rebonds, :transcoder_address, :orchestrator_address
    rename_column :livepeer_events, :transcoder_address, :orchestrator_address
  end
end
