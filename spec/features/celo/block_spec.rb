require 'features_helper'

describe 'celo block details' do
  let(:chain) { create(:celo_chain) }
  let(:height) { '1614750' }

  it 'visiting block details', :vcr do
    visit "/celo/chains/#{chain.slug}/blocks/#{height}"

    expect(page).to have_content('HEIGHT')
    expect(page).to have_content('TIMESTAMP')
    expect(page).to have_content('RAW JSON')
    expect(page).to have_content('Transactions')
    expect(page).to have_content('Validator groups')
    expect(page).to have_content('Figment')
  end
end
