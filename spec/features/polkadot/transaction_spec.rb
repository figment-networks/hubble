require 'features_helper'

describe 'polkadot transaction details', :vcr do
  let(:chain) { create(:polkadot_chain) }
  let(:block_id) { 3189176 }

  before do
    visit "/polkadot/chains/#{chain.slug}/blocks/#{block_id}/transactions/#{transaction_id}"
  end

  context 'nomination' do
    let(:transaction_id) { '0x02500ac3e55c573ee8e4dbc29cba6919fb8be4917ef7ffca678264fd28973704' }

    it 'visiting transaction page' do
      expect(page).to have_content('Nominate')
      expect(page).to have_content('H2C39kN9b88eTrvhUyVn4i8MiKLVSSpoTX8SS1uiYFeKbZM')
      expect(page).to have_content('DxDFNGjNrTHWhes35E2ht7cJSNWpedoQzre6rVXBtMV3jjB')
      expect(page).to have_content('SUCCESS')
      expect(page).to have_content(block_id)
      expect(page).to have_content(transaction_id)
    end
  end

  context 'transfer' do
    let(:transaction_id) { '0x02500ac3e55c573ee8e4dbc29cba6919fb8be4917ef7ffca678264fd28973705' }

    it 'visiting transaction page' do
      expect(page).to have_content('Send')
      expect(page).to have_content('From')
      expect(page).to have_content('To')
      expect(page).to have_content('Dn7CpiwnJbBKz6gckRw2H4XUEeVCA41ZqxYWVdaKZEYZGB4')
      expect(page).to have_content('500 KSM')
      expect(page).to have_content('ERROR')
      expect(page).to have_content(block_id)
      expect(page).to have_content(transaction_id)
    end
  end

  context 'Payout stakers' do
    let(:transaction_id) { '0x02500ac3e55c573ee8e4dbc29cba6919fb8be4917ef7ffca678264fd28973709' }

    it 'visiting transaction page' do
      expect(page).to have_content('Payout stakers')
      expect(page).to have_content('Stash account')
      expect(page).to have_content('Era')
      expect(page).to have_content('HTurKrQe9H5n5LPYuMFURPphGJfoRTJRM1zW9yXEBjdArkw')
      expect(page).to have_content(block_id)
      expect(page).to have_content(transaction_id)
    end
  end

  context 'Unknown type' do
    let(:transaction_id) { '0x02500ac3e55c573ee8e4dbc29cba6919fb8be4917ef7ffca678264fd28973707' }

    it 'visiting transaction page' do
      expect(page).to have_content('Module')
      expect(page).to have_content('Call')
      expect(page).to have_content('PARAMETERS')
      expect(page).to have_content(block_id)
      expect(page).to have_content(transaction_id)
    end
  end
end
