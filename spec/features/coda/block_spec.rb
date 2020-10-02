require 'features_helper'

describe 'coda block', :vcr do
  let(:chain) { create :coda_chain }

  before do
    visit coda_chain_block_path(chain, '6079')
  end

  it 'displays block details' do
    expect(page).to have_text '3j7Fqw9esogUaXtzjE1CtnR24pc1tRReFHHV'
    expect(page).to have_text 'Block Details'
    expect(page).to have_text 'Transactions'
    expect(page).to have_text 'SNARK Jobs'
    expect(page).to have_text 'Height'
    expect(page).to have_text 'Timestamp'

    within '.block-details' do
      expect(page).to have_text 'Producer'
      expect(page).to have_text '4vsRCVaJmjRqg6SvTcMLwNfpTLP2XwdUNN943vK7gGSeXtj'

      expect(page).to have_text 'Total Currency'
      expect(page).to have_text '23,576,900.002 CODA'
    end

    within 'table.transactions' do
      expect(page.all('tbody > tr').size).to eq 10
    end

    within 'table.snarkers' do
      expect(page.all('tbody > tr').size).to eq 1
    end

    within '.block-height' do
      expect(page).to have_text '6079'
    end
  end
end
