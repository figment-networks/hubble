require 'features_helper'

describe 'celo validator groups' do
  let(:chain) { create(:celo_chain) }
  let(:address) { '0x35aE10F412503aBcf9275133613E8df7f56E72Be' }

  it 'visiting list of validator groups', :vcr do
    visit "/celo/chains/#{chain.slug}"

    expect(page).to have_content('CELO')
    expect(page).to have_content('CURRENT BLOCK')
    expect(page).to have_content('VOTING SHARES')
    expect(page).to have_content('AVERAGE BLOCK TIME')
    expect(page).to have_content('Past 48 hours')
    expect(page).to have_content('UP')
  end

  it 'visiting validator group details', :vcr do
    visit "/celo/chains/#{chain.slug}/validator_groups/#{address}"

    expect(page).to have_content('CELO')
    expect(page).to have_content('AVERAGE UPTIME')
    expect(page).to have_content('VOTES')
    expect(page).to have_content('LIFETIME')
    expect(page).to have_content('Validators')
    expect(page).to have_content('100 %')
  end
end
