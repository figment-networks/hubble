require 'features_helper'

describe 'skale validator groups' do
  let(:chain) { create(:skale_chain) }

  it 'visiting list of validators', :vcr do
    visit "/skale/chains/#{chain.slug}"

    expect(page).to have_content('Active Delegations')
    expect(page).to have_content('Validators')
    expect(page).to have_content('Total Staked')
    expect(page).to have_content('21,351,442 SKL')
  end
end
