FactoryBot.define do
  factory :oasis_chain, class: 'Oasis::Chain' do
    name { 'OasisChain' }
    sequence(:slug) { |n| "oasis-#{n}" }
    api_url { 'https://127.0.0.1/oasis' }
    primary { false }
    testnet { false }
    disabled { false }
    validator_event_defs do
      [{ 'kind' => 'voting_power_change', 'height' => 1 },
       { 'kind' => 'active_set_inclusion', 'height' => 1 },
       { 'kind' => 'reward_cut_change', 'height' => 1 },
       { 'kind' => 'slash', 'height' => 1 },
       { 'm' => 1000, 'n' => 50, 'kind' => 'n_of_m', 'height' => 1 },
       { 'n' => 150, 'kind' => 'n_consecutive', 'height' => 1 }]
    end
  end
end
