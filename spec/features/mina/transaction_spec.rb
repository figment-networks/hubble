require 'features_helper'

describe 'mina transaction', :vcr do
  let(:chain) { create :mina_chain }
  let(:tx) do
    'CkpZYwZYxj8uwsEmT4MBxrHuuAtPfwV31k9bj1P12wgyRFBaoWhuC'
  end

  before do
    visit mina_chain_transaction_path(chain, tx)
  end

  it 'displays the transaction details' do
    expect(page).to have_text 'CkpZYwZYxj8uwsEmT4MBxrHuuAtPfwV31k9bj1P12wgyRFBaoWhuC'
    expect(page).to have_text 'Payment'
    expect(page).to have_text 'B62qokL7r6Q21BXRqk6MGVbsB8ETkvA9cyJ6QX6LsFMHERv...'
    expect(page).to have_text '500 MINA'
    expect(page).to have_text '7274'
  end
end
