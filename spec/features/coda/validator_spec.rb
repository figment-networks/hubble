require 'features_helper'

describe 'coda validator', :vcr do
  let(:chain)      { create :coda_chain }
  let(:public_key) { '4vsRCVaJmjRqg6SvTcMLwNfpTLP2XwdUNN943vK7gGSeXtjvzhzSA2RhpK9uSQHxYhAorPu9bxHSUJB8mrwobJtpnfo8W8g86EfDMTz9wz634E6ZaGajQUBDPvKsujPTjYyACMNik6EsMPYz' }

  before do
    visit coda_chain_validator_path(chain, public_key)
  end

  it 'displays validator details' do
    expect(page).to have_text 'Recent Transactions'
    expect(page).to have_text 'Delegations'
    expect(page).to have_text 'Staking Balance'
    expect(page).to have_text 'Lifetime'
    expect(page).to have_text 'Block Production'

    within '.recent-transactions' do
      expect(page).to have_link 'Search Transactions', href: coda_chain_transactions_path(chain, account: public_key)

      within 'table.transactions' do
        expect(page.all('tbody tr').size).to eq 25
      end
    end

    within '.validator-staking' do
      expect(page).to have_text '186,205.658 CODA'
    end

    within '.validator-lifetime' do
      expect(page).to have_text 'June 10, 2020 at 17:15 UTC'
      expect(page).to have_text 'July 15, 2020 at 23:21 UTC'
      expect(page).to have_text '1221'
    end

    within '.validator-delegations' do
      expect(page.all('tbody > tr').size).to eq 1
    end

    within '.validator-blocks' do
      block_link = page.all('a').last[:href]
      expect(block_link).to include coda_chain_block_path(chain, '6082')
    end
  end
end
