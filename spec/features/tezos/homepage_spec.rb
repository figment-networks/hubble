require 'features_helper'

describe 'tezos homepage' do
  let!(:chain) { create(:tezos_chain) }

  before do
    allow(Indexer::Event).to receive(:list).and_return({ events: [Indexer::Event.new(sender_id: 'asdf123', type: 'baker_activated'), Indexer::Event.new(sender_id: 'asdf456', type: 'baker_deactivated')] })
    visit '/tezos'
  end

  it 'visiting as not signed in user', :vcr do
    expect(page).to have_content('Tezos')
    expect(page).to have_content(chain.name)
    expect(page).to have_content('START')
    expect(page).to have_content('END')
    expect(page).to have_content('MISSED BAKES')
    expect(page).to have_content('MISSED ENDORSEMENT SLOTS')
    expect(page).to have_content('SNAPSHOT CYCLE')
    expect(page).to have_content('REWARDS AVAILABLE')
    expect(page).to have_content('Latest Events')
    expect(page).to have_content('Baker Performance')

    expect(page).to have_content('asdf123')
    expect(page).to have_content('Baker Activated')
    expect(page).to have_css('.fa-toggle-on')

    expect(page).to have_content('asdf456')
    expect(page).to have_content('Baker Deactivated')
    expect(page).to have_css('.fa-toggle-off')
  end

  it 'can access governance page', :vcr do
    click_link 'Governance'
    expect(page).to have_content('Governance Proposals')
    expect(page).to have_content('Current Period')
  end

  it 'can see baker performance', :vcr do
    baker_address = 'tz2Q7Km98GPzV1JLNpkrQrSo5YUhPfDp6LmA'
    click_link baker_address
    expect(page).to have_content(baker_address)
    expect(page).to have_content('All Time Baking %')
    expect(page).to have_content('All Time Endorsing %')
    expect(page).to have_content('Baking History by Cycle')
    expect(page).to have_content('Endorsing History by Cycle')
    expect(page).to have_content('Cycle Reports')
  end
end
