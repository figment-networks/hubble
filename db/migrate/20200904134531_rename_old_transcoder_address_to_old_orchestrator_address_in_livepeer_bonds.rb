class RenameOldTranscoderAddressToOldOrchestratorAddressInLivepeerBonds < ActiveRecord::Migration[5.2]
  def change
    rename_column :livepeer_bonds, :old_transcoder_address, :old_orchestrator_address
  end
end
