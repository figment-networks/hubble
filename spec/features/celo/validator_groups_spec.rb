require 'features_helper'

describe 'celo validator groups' do
  let(:chain) { create(:celo_chain) }

  it 'visiting list of validator groups', :vcr do
    visit "/celo/chains/#{chain.slug}"

    expect(page).to have_content('Celo')
    expect(page).to have_content('Current Block')
    expect(page).to have_content('Total Shares')
    expect(page).to have_content('Average Block Time')
    expect(page).to have_content('Past 48 hours:')
    expect(page).to have_content('100 %')
  end
end
