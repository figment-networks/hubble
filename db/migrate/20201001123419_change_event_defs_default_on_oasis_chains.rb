class ChangeEventDefsDefaultOnOasisChains < ActiveRecord::Migration[5.2]
  def up
    change_column_default :oasis_chains, :validator_event_defs, [{"kind"=>"voting_power_change", "height"=>0},
                                                  {"kind"=>"active_set_inclusion", "height"=>0},
                                                  {"kind"=>"reward_cut_change", "height"=>0},
                                                  {"kind"=>"slash", "height"=>0}]

  end

  def down
    change_column_default :oasis_chains, :validator_event_defs, [{"kind"=>"voting_power_change", "height"=>0},
                                                  {"kind"=>"n_of_m", "n"=>50, "m"=>1000, "height"=>0}]
  end
end
