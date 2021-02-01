require 'features_helper'

describe 'mina account', :vcr do
  let(:chain)      { create :mina_chain }
  let(:public_key) do
    '4vsRCVaJmjRqg6SvTcMLwNfpTLP2XwdUNN943vK7gGSeXtjvzhzSA2RhpK9uSQHxYhAorPu9bxHSUJB8mrwobJtpnfo8W8g86EfDMTz9wz634E6ZaGajQUBDPvKsujPTjYyACMNik6EsMPYz'
  end

  before do
    visit mina_chain_account_path(chain, public_key)
  end

  it 'displays account details' do
    expect(page).to have_text 'Recent Transactions'
    expect(page).to have_text 'Delegations'
    expect(page).to have_text 'Balance'
    expect(page).to have_text 'Lifetime'

    within '.recent-transactions' do
      expect(page).to have_link 'Search Transactions', href: mina_chain_transactions_path(chain,
                                                                                          account: public_key)

      within 'table.transactions' do
        expect(page.all('tbody tr').size).to eq 25
      end
    end

    within '.account-balance' do
      expect(page).to have_text '186,405.66 MINA'
      expect(page).to have_text 'Not delegating stake'
    end

    within '.account-lifetime' do
      expect(page).to have_text 'June 10, 2020 at 17:15 UTC'
      expect(page).to have_text 'July 15, 2020 at 23:30 UTC'
    end

    within '.account-delegations' do
      expect(page).to have_text 'Account does not have any delegations'
    end
  end
end
