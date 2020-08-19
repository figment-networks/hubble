require 'features_helper'

feature 'Livepeer delegator list events' do
  let!(:chain) { create(:livepeer_chain, rounds: [round], transcoders: [transcoder]) }
  let!(:transcoder) { create(:livepeer_transcoder) }
  let!(:delegator) { create(:livepeer_delegator, chain_id: chain.id, transcoder_address: transcoder.address) }
  let!(:delegator_list) { create(:livepeer_delegator_list, chain_id: chain.id, addresses: [delegator.address], user_id: user.id) }
  let!(:events) { create_list(:livepeer_event, 3, transcoder_address: transcoder.address) }
  let!(:round) { create(:livepeer_round, events: events) }
  let!(:user) { create(:user) }

  before { log_in(user) }

  scenario 'viewing events for a delegator list' do
    visit "/livepeer/chains/#{chain.slug}/delegator_lists/#{delegator_list.id}/events"

    expect(page).to have_link 'Events'
    expect(page).to have_link 'Delegator Lists'

    expect(page).to have_content("Events for #{delegator_list.name}")
    expect(page).to have_content('showing 1-3 of 3 total events')
    expect(page).to have_content transcoder.name_or_address
    expect(page).to have_content round.number
  end
end
