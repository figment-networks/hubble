require 'features_helper'

describe 'Livepeer Orchestrators' do
  let!(:chain) { create(:livepeer_chain) }

  let!(:orchestrator) do
    create(
      :livepeer_orchestrator,
      chain: chain,
      name: 'Example Orchestrator',
      website_url: 'http://orchestrator.example',
      address: '0x9ffda5fa31c5fcc21de84a1b0a849efa0dd9d264',
      reward_cut: 40,
      fee_share: 0,
      total_stake: 1_234_567
    )
  end

  let!(:events) do
    [
      create(
        :livepeer_event,
        round: create(:livepeer_round, chain: chain, number: 1673),
        type: 'Livepeer::Events::RewardCutChange',
        timestamp: '2020-03-09 12:16',
        orchestrator_address: orchestrator.address,
        data: { reward_cut: '30.0' }
      ),
      create(
        :livepeer_event,
        round: create(:livepeer_round, chain: chain, number: 1734),
        type: 'Livepeer::Events::MissedRewardCall',
        timestamp: '2020-05-02 21:37',
        orchestrator_address: orchestrator.address
      ),
      create(
        :livepeer_event,
        round: create(:livepeer_round, chain: chain, number: 1806),
        type: 'Livepeer::Events::Deactivation',
        timestamp: '2020-07-06 14:18',
        orchestrator_address: orchestrator.address
      ),
      create(
        :livepeer_event,
        round: create(:livepeer_round, chain: chain, number: 1848),
        type: 'Livepeer::Events::Slashing',
        timestamp: '2020-08-12 18:07',
        orchestrator_address: orchestrator.address,
        data: { penalty: '20648.0' }
      )
    ]
  end

  let!(:delegators) do
    [
      create(
        :livepeer_delegator,
        chain: chain,
        orchestrator_address: orchestrator.address,
        address: '0xe1c2047311f5db1e082d722f2f867d54c6f61f03',
        pending_stake: 1_230_000
      ),
      create(
        :livepeer_delegator,
        chain: chain,
        orchestrator_address: orchestrator.address,
        address: '0x308a23b3e963d253252d2a7c6fabd81338e66c7f',
        pending_stake: 4567
      )
    ]
  end

  it 'visiting the orchestrator page' do
    visit "/livepeer/chains/#{chain.slug}"

    click_link 'Example Orchestrator'

    expect(page).to have_content('Example Orchestrator')
    expect(page).to have_link('Visit Site', href: 'http://orchestrator.example')
    expect(page).to have_content('9FFDA5FA31C5FCC21DE84A1B0A849EFA0DD9D264')

    expect(page).to have_content('Event History — most recent 20')
    expect(page).to have_content("Slashed with penalty 20.65K LPT in round 1848\nAugust 12, 2020\nat 18:07 UTC")
    expect(page).to have_content("Deactivated in round 1806\nJuly 06, 2020\nat 14:18 UTC")
    expect(page).to have_content("Missed a reward call in round 1734\nMay 02, 2020\nat 21:37 UTC")
    expect(page).to have_content("Reward cut changed to 30% in round 1673\nMarch 09, 2020\nat 12:16 UTC")

    expect(page).to have_content('Delegators')
    expect(page).to have_content('E1C2047311F5DB1E082D722F2F867D54C6F61F03 1.23M LPT 99.63%')
    expect(page).to have_content('308A23B3E963D253252D2A7C6FABD81338E66C7F 4.57K LPT 0.37%')

    expect(page).to have_content("Reward Cut\n40%")
    expect(page).to have_content("Fee Share\n0%")
    expect(page).to have_content("Total Stake\n1.23M LPT")
  end
end
