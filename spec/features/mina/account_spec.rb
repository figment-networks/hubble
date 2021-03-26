require 'features_helper'

describe 'mina account', :vcr do
  let(:chain) { create :mina_chain }
  let(:public_key) do
    'B62qmsYXFNNE565yv7bEMPsPnpRCsMErf7J2v5jMnuKQ1jgwZS8BzXS'
  end

  before do
    visit mina_chain_account_path(chain, public_key)
  end

  it 'displays account details' do
    expect(page).to have_text 'Recent Transactions'
    expect(page).to have_text 'Delegations'
    expect(page).to have_text 'BALANCE'
    expect(page).to have_text 'LIFETIME'

    within '.recent-transactions' do
      expect(page).to have_link 'Search Transactions', href: mina_chain_transactions_path(chain,
                                                                                          account: public_key)

      within 'table.transactions' do
        expect(page.all('tbody tr').size).to eq 1
      end
    end

    within '.account-balance' do
      expect(page).to have_text '1,693,980.638 MINA'
      expect(page).to have_text '1,693,980.638 MINA'
    end

    within '.account-lifetime' do
      expect(page).to have_text 'March 17, 2021 at 23:12 UTC'
      expect(page).to have_text 'March 18, 2021 at 14:15 UTC'
    end

    within '.account-delegations' do
      expect(page).to have_text '1,693,980.638 MINA'
      expect(page).to have_text '100%'
    end
  end
end
