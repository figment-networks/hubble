require 'features_helper'

describe 'celo block details' do
  let(:chain) { create(:celo_chain) }
  let(:height) { '290813' }

  it 'visiting block details', :vcr do
    visit "/celo/chains/#{chain.slug}/blocks/#{height}"

    expect(page).to have_content('HEIGHT')
    expect(page).to have_content('TIMESTAMP')
    expect(page).to have_content('RAW JSON')
    expect(page).to have_content('Transactions')
    expect(page).to have_content('0x50bfadecfebb773b01b9f0e5a171eaca58e2ac6e3024609d7997320...')
    expect(page).to have_content('Validator groups')
  end
end
