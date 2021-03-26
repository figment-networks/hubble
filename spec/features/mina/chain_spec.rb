require 'features_helper'

describe 'mina home', :vcr do
  let(:chain) { create :mina_chain }

  before do
    visit mina_chain_path(chain)
  end

  it 'displays chain sections' do
    expect(page).to have_link 'Transaction Search', href: mina_chain_transactions_path(chain)
    expect(page).to have_text 'DAILY VOLUME'

    within '.validators' do
      expect(page).to have_text 'Validators'
      expect(page).to have_text '5'
    end

    within '.chain-block' do
      expect(page).to have_text 'CURRENT BLOCK'
      expect(page).to have_link '727', href: mina_chain_block_path(chain, '727')
    end

    within '.chain-pool' do
      expect(page).to have_text 'COMMUNITY POOL'
      expect(page).to have_text '3,038,159.9k MINA'
      expect(page).to have_text '2,406,968.695k MINA'
    end

    within '.chain-block-times' do
      expect(page).to have_text 'AVERAGE BLOCK TIME'
      expect(page).to have_text '3.75 minutes'
    end

    within '.transactions-stats' do
      expect(page).to have_button 'Payments'
      expect(page).to have_button 'Fees'
      expect(page).to have_button 'Worker'
    end
  end
end
