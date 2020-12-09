require 'features_helper'

describe 'celo validator groups' do
  let(:chain) { create(:celo_chain) }

  it 'visiting list of validator groups', :vcr do
    visit "/celo/chains/#{chain.slug}"

    expect(page).to have_content('CELO')
    expect(page).to have_content('CURRENT BLOCK')
    expect(page).to have_content('VOTING SHARES')
    expect(page).to have_content('AVERAGE BLOCK TIME')
    expect(page).to have_content('Past 48 hours')
    expect(page).to have_content('100 %')
  end
end
