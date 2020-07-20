require 'features_helper'

feature 'tezos homepage' do
  let!(:chain) { create(:tezos_chain) }
  before(:each) { visit "/tezos" }

  scenario 'visiting as not signed in user', :vcr do
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
  end

  scenario 'can access governance page', :vcr do
    click_link 'Governance'
    expect(page).to have_content('Governance Proposals')
    expect(page).to have_content('Current Period')
  end

  scenario 'can see baker performance', :vcr do
    baker_address = "tz2Q7Km98GPzV1JLNpkrQrSo5YUhPfDp6LmA"
    click_link baker_address
    expect(page).to have_content(baker_address)
    expect(page).to have_content('All Time Baking %')
    expect(page).to have_content('All Time Endorsing %')
    expect(page).to have_content('Baking History by Cycle')
    expect(page).to have_content('Endorsing History by Cycle')
    expect(page).to have_content('Cycle Reports')
  end
end
