FactoryBot.define do
  factory :iris_validator, class: 'Iris::Validator' do
    address { 'AC2D56057CD84765E6FBE318979093E8E44AA18F' }
    current_voting_power { '2668620' }
    latest_block_height { nil }
  end
end

FactoryBot.define do
  factory :iris_validator_synced, class: 'Iris::Validator' do
    address { 'AC2D56057CD84765E6FBE318979093E8E44AA18F' }
    current_voting_power { 2636453 }
    created_at { Time.now.utc }
    latest_block_height { 2723613 }
    info { { 'jailed': false, 'status': 2, 'tokens': '13039122440841', 'commission': { 'update_time': '2019-03-13T23:00:00Z', 'commission_rates': { 'rate': '0.040000000000000000', 'max_rate': '1.000000000000000000', 'max_change_rate': '0.020000000000000000' } }, 'description': { 'details': 'We are the leading staking service provider for blockchain projects. Join our community to help secure networks and earn rewards. We know staking.', 'moniker': '🐠stake.fish', 'website': 'stake.fish', 'identity': '90B597A673FC950E' }, 'unbonding_time': '1970-01-01T00:00:00Z', 'consensus_pubkey': 'cosmosvalconspub1zcjduepq6fpkt3qn9xd7u44478ypkhrvtx45uhfj3uhdny420hzgsssrvh3qnzwdpe', 'delegator_shares': '13039122440841.000000000000000000', 'operator_address': 'cosmosvaloper1sjllsnramtg3ewxqwwrwjxfgc4n4ef9u2lcnj0', 'unbonding_height': '0', 'min_self_delegation': '1' } }
    first_seen_at { Time.now.utc }
    total_precommits { 0 }
    current_uptime { 1 }
    total_proposals { 3 }
    last_updated { Time.now.utc }
    owner { 'cosmosvaloper1sjllsnramtg3ewxqwwrwjxfgc4n4ef9u2lcnj0' }
    moniker { '🐠stake.fish' }
  end
end
