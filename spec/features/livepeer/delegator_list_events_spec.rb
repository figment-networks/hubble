require 'features_helper'

describe 'Livepeer Delegator List Events' do
  let!(:user) { create(:user) }

  let!(:chain) { create(:livepeer_chain) }
  let!(:round) { create(:livepeer_round, chain: chain, number: 1000) }
  let!(:orchestrator) { create(:livepeer_orchestrator, chain: chain) }

  let!(:events) do
    create_pair(
      :livepeer_event,
      round: round,
      orchestrator_address: orchestrator.address
    )
  end

  let!(:delegator) do
    create(
      :livepeer_delegator,
      chain: chain,
      orchestrator_address: orchestrator.address
    )
  end

  let!(:delegator_list) do
    create(
      :livepeer_delegator_list,
      user: user,
      chain: chain,
      addresses: [delegator.address]
    )
  end

  context 'as a signed in user' do
    before { log_in(user) }

    it 'viewing events for a delegator list' do
      visit "/livepeer/chains/#{chain.slug}/delegator_lists"

      find('a .fa-clock').click

      expect(page).to have_content("Events for #{delegator_list.name}")

      expect(page).to have_content('C22BC16573B4A9844499CDB01B3B07268A82299B' \
        ' changed reward cut to 30% 1000')
    end
  end
end
