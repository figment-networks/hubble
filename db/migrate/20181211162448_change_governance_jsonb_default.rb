class ChangeGovernanceJsonbDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :cosmos_chains, :governance, from: "{}", to: {}
  end
end
