require 'features_helper'

describe 'Cosmos prestart page' do
  let(:chain) { create(:cosmos_chain) }

  it 'visiting prestart page', :vcr do
    visit "/cosmos/chains/#{chain.slug}/prestart"
    expect(page).to have_content(chain.name)
    expect(page).to have_content('Chain has not yet started.')
    expect(page).to have_content('Waiting for prevotes...')
    expect(page).to have_content('prevote')
  end
end
