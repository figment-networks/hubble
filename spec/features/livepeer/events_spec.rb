require 'features_helper'

describe 'Livepeer Events' do
  let!(:chain) { create(:livepeer_chain) }

  let!(:round) { create(:livepeer_round, chain: chain, number: 1000) }
  let!(:orchestrator) { create(:livepeer_orchestrator, chain: chain, name: 'Example Orchestrator') }

  let!(:events) do
    [
      create(
        :livepeer_event,
        round: round,
        type: 'Livepeer::Events::RewardCutChange',
        orchestrator_address: orchestrator.address,
        data: { reward_cut: '12.34' }
      ),
      create(
        :livepeer_event,
        round: round,
        type: 'Livepeer::Events::MissedRewardCall',
        orchestrator_address: orchestrator.address
      ),
      create(
        :livepeer_event,
        round: round,
        type: 'Livepeer::Events::Deactivation',
        orchestrator_address: orchestrator.address
      ),
      create(
        :livepeer_event,
        round: round,
        type: 'Livepeer::Events::Slashing',
        orchestrator_address: orchestrator.address,
        data: { penalty: '12345.0' }
      )
    ]
  end

  it 'shows the events page', :vcr do
    visit "livepeer/chains/#{chain.slug}"

    click_link 'Events'

    expect(page).to have_current_path("/livepeer/chains/#{chain.slug}/events", ignore_query: true)

    expect(page).to have_content('Events')
    expect(page).to have_content('showing 1-4 of 4 total events')

    expect(page).to have_content('Example Orchestrator slashed with penalty 12.35K LPT 1000')
    expect(page).to have_content('Example Orchestrator deactivated 1000')
    expect(page).to have_content('Example Orchestrator missed a reward call 1000')
    expect(page).to have_content('Example Orchestrator changed reward cut to 12.34% 1000')
  end

  it 'shows the events page for a single orchestrator' do
    visit "/livepeer/chains/#{chain.slug}/events?orchestrator_address=#{orchestrator.address}"

    expect(page).to have_content('Events')
    expect(page).to have_content('showing 1-4 of 4 total events')

    expect(page).to have_content('Slashed with penalty 12.35K LPT 1000')
    expect(page).to have_content('Deactivated 1000')
    expect(page).to have_content('Missed a reward call 1000')
    expect(page).to have_content('Reward cut changed to 12.34% 1000')
  end
end
