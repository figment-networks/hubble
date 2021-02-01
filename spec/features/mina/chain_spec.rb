require 'features_helper'

describe 'mina home', :vcr do
  let(:chain) { create :mina_chain }

  before do
    visit mina_chain_path(chain)
  end

  it 'displays chain sections' do
    expect(page).to have_link 'Transaction Search', href: mina_chain_transactions_path(chain)
    expect(page).to have_text 'Daily Volume'

    within '.validators' do
      expect(page).to have_text 'Validators'
      expect(page).to have_text '180 total'
    end

    within '.chain-block' do
      expect(page).to have_text 'Current Block'
      expect(page).to have_link '7388', href: mina_chain_block_path(chain, '7388')
    end

    within '.card.chain-pool' do
      expect(page).to have_text 'Community Pool'
      expect(page).to have_text '23,839,900.002 MINA'
      expect(page).to have_text '1,557,594.15 MINA'
    end

    within '.card.chain-block-times' do
      expect(page).to have_text 'Average Block Time'
      expect(page).to have_text '442.8 seconds'
    end

    within '.card.transactions-stats' do
      expect(page).to have_button 'Payments'
      expect(page).to have_button 'Fees'
      expect(page).to have_button 'Worker'
    end
  end
end
