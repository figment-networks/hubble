class FixRenameCodaToMina < ActiveRecord::Migration[5.2]
  def change
    rename_table :coda_chains, :mina_chains
  end
end
