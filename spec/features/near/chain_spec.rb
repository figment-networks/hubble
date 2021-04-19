require 'features_helper'

describe 'near chain page' do
  let(:chain) { create(:near_chain) }

  it 'visiting chain page', :vcr do
    visit "/near/chains/#{chain.slug}"
    expect(page).to have_content('AVERAGE BLOCK TIME')
    expect(page).to have_content('425M')
    expect(page).to have_content('Validators')
    expect(page).to have_content('5,037,583.587')
  end
end
