require 'features_helper'

feature 'hubble homepage networks data' do
  let!(:cosmos_chain) { create(:cosmos_chain, primary: true, dead: false, disabled: false, last_sync_time: "2020-07-29 18:30:12") }
  let!(:validators) { create(:cosmos_validator_synced, chain: cosmos_chain) }
  let!(:blocks) do
    [
        create(:cosmos_block,
               chain: cosmos_chain),
        create(:cosmos_block,
               chain: cosmos_chain,
               id_hash: '199FE45509EE7BC19B7B842BAC9EC9EF28738F170D8081355778CC927263D556',
               timestamp: '2020-07-20 12:21:37.698402',
               height: '2668618'),
        create(:cosmos_block,
               chain: cosmos_chain,
               id_hash: 'B1C96F3A563BB6D94A542A7CBF4DC0439E6389A321E0966E9A76F423145B3327',
               timestamp: '2020-07-20 12:21:37.698402',
               height: '2668612')
    ]
  end


  scenario 'when node is unavailable', :vcr do
    cosmos_chain.update_attributes(rewards_rate: nil, daily_rewards: nil, staking_participation: nil)

    visit '/'

    expect(page).to have_content('Token Price')
    expect(page).to have_content('Validator Set Size')
    expect(page).to have_content('Block Time')
    expect(page).to_not have_content('Daily Rewards')
    expect(page).to_not have_content('Rewards')
    expect(page).to_not have_content('Staking Participation')
  end

  scenario 'when node is available', :vcr do
    cosmos_chain.update_attributes(rewards_rate: 3.7, daily_rewards: 45000, staking_participation: 73)

    visit '/'

    expect(page).to have_content('Token Price')
    expect(page).to have_content('Validator Set Size')
    expect(page).to have_content('Block Time')
    expect(page).to have_content('Daily Rewards')
    expect(page).to have_content('Rewards')
    expect(page).to have_content('Staking Participation')
  end
end
