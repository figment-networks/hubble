class AddValidatorEventDefsToOasisChains < ActiveRecord::Migration[5.2]
  def change
    change_table :oasis_chains do |t|
      t.jsonb "validator_event_defs", default: [{"kind"=>"voting_power_change", "height"=>0}, {"kind"=>"n_of_m", "n"=>50, "m"=>1000, "height"=>0}]
    end
  end
end
