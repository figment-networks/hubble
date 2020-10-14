require 'features_helper'

describe 'polkadot transaction details', :vcr do
  let(:chain) { create(:polkadot_chain) }
  let(:block_id) { 1293572 }

  before do
    visit "/polkadot/chains/#{chain.slug}/blocks/#{block_id}/transactions/#{transaction_id}"
  end

  context 'transfer' do
    let(:transaction_id) { '0x81530d93a9fa83f13bda35f291268cfa5cf33a04e39e7cd5227ce446a185a1f1' }

    it 'visiting transaction page' do
      expect(page).to have_content('Send')
      expect(page).to have_content('From')
      expect(page).to have_content('To')
      expect(page).to have_content('15kUt2i86LHRWCkE3D9Bg1HZAoc2smhn1fwPzDERTb1BXAkX')
      expect(page).to have_content('1,482 DOT')
      expect(page).to have_content('SUCCESS')
      expect(page).to have_content(block_id)
      expect(page).to have_content(transaction_id)
    end
  end

  context 'Unknown type' do
    let(:transaction_id) { '0xdad21be1be6bad088337e936105fa3aebf415817f8b5a17f314d051afb198aae' }
    let(:block_id) { 1295421 }

    it 'visiting transaction page' do
      expect(page).to have_content('Module')
      expect(page).to have_content('Call')
      expect(page).to have_content('PARAMETERS')
      expect(page).to have_content(block_id)
      expect(page).to have_content(transaction_id)
    end
  end
end
