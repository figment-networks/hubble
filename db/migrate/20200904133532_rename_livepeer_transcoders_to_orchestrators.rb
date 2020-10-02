class RenameLivepeerTranscodersToOrchestrators < ActiveRecord::Migration[5.2]
  def change
    rename_table :livepeer_transcoders, :livepeer_orchestrators
  end
end
