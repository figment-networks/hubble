require 'features_helper'

describe 'celo transaction details', :vcr do
  let(:chain) { create(:celo_chain) }
  let(:block_id) { 1614760 }

  before do
    visit "/celo/chains/#{chain.slug}/blocks/#{block_id}/transactions/#{transaction_id}"
  end

  context 'transfer' do
    let(:transaction_id) { '0x929145bcb26a7f14fbf0758105b7a778da760453c0c7640e3a5d83fb78a0459c' }

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
