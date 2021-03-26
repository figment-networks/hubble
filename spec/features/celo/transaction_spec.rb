require 'features_helper'

describe 'celo transaction details', :vcr do
  let(:chain) { create(:celo_chain) }
  let(:block_id) { 290813 }

  before do
    visit "/celo/chains/#{chain.slug}/blocks/#{block_id}/transactions/#{transaction_id}"
  end

  context 'transfer' do
    let(:transaction_id) { '0x50bfadecfebb773b01b9f0e5a171eaca58e2ac6e3024609d7997320d920b84c7' }

    it 'visiting transaction page' do
      expect(page).to have_content('Transfers')
      expect(page).to have_content('FROM')
      expect(page).to have_content('TO')
      expect(page).to have_content('AMOUNT')
      expect(page).to have_content('HEIGHT')
      expect(page).to have_content('GAS')
      expect(page).to have_content('SUCCESS')
      expect(page).to have_content(block_id)
      expect(page).to have_content(transaction_id)
    end
  end
end
