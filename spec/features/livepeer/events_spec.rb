require 'features_helper'

feature 'Livepeer events' do
  let!(:chain) { create(:livepeer_chain, rounds: [round], transcoders: [transcoder]) }
  let!(:events) { create_list(:livepeer_event, 3, transcoder_address: transcoder.address) }
  let!(:transcoder) { create(:livepeer_transcoder) }
  let!(:round) { create(:livepeer_round, events: events) }

  scenario 'visiting all events view', :vcr do

    visit "livepeer/chains/#{chain.slug}"

    click_link 'Events'

    expect(page.current_path).to eq("/livepeer/chains/#{chain.slug}/events")

    expect(page).to have_link 'Events'
    expect(page).to have_link 'Delegator Lists'

    expect(page).to have_content 'Events'
    expect(page).to have_content "showing 1-3 of 3 total events"
    expect(page).to have_content transcoder.name_or_address
    expect(page).to have_content round.number
  end

  scenario 'visiting events view for a single transcoder' do
    visit "/livepeer/chains/#{chain.slug}/transcoders/#{transcoder.address}"

    click_link 'All Events'

    expect(page.current_path).to eq("/livepeer/chains/#{chain.slug}/events")

    expect(page).to have_content "Events for #{transcoder.name_or_address}"
    expect(page).to have_content 'showing 1-3 of 3 total events'
    expect(page).to have_content round.number

  end
end
