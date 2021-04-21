require 'features_helper'

describe 'mina validator', :vcr do
  let(:chain)      { create :mina_chain }
  let(:public_key) do
    'B62qmFf6UZn2sg3j8bYLGmMinzS2FHX6hDM71nFxAfMhvh4hnGBtkBD'
  end

  before do
    visit mina_chain_validator_path(chain, public_key)
  end

  it 'displays validator details' do
    expect(page).to have_text 'Recent Transactions'
    expect(page).to have_text 'Delegations'
    expect(page).to have_text 'STAKING BALANCE'
    expect(page).to have_text 'LIFETIME'
    expect(page).to have_text 'BLOCKS'
    expect(page).to have_text 'STAKING BALANCE HISTORY'
    expect(page).to have_text 'BLOCKS PRODUCED'

    within '.recent-transactions' do
      expect(page).to have_link 'Search Transactions', href: mina_chain_transactions_path(chain,
                                                                                          account: public_key)

      within 'table.transactions' do
        expect(page.all('tbody tr').size).to eq 25
      end
    end

    within '.validator-staking' do
      expect(page).to have_text '14,784,005.98 MINA'
    end

    within '.validator-lifetime' do
      expect(page).to have_text 'First Seen'
      expect(page).to have_text 'Last Seen'
      expect(page).to have_text 'Blocks Produced'
    end

    within '.validator-delegations' do
      expect(page.all('tbody > tr').size).to eq 32
    end

    within '.validator-blocks' do
      block_link = page.all('a').last[:href]
      expect(block_link).to include mina_chain_block_path(chain, '4990')
    end
  end
end
