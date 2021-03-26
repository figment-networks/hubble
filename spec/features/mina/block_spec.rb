require 'features_helper'

describe 'mina block', :vcr do
  let(:chain) { create :mina_chain }

  before do
    visit mina_chain_block_path(chain, '6079')
  end

  it 'displays block details' do
    expect(page).to have_text '3NLUNGXBvXsdMxktBWZYR9ZjTwBWDCYh6WRtp7SbPxNEzMQ...'
    expect(page).to have_text 'Block Details'
    expect(page).to have_text 'Transactions'
    expect(page).to have_text 'SNARK Jobs'
    expect(page).to have_text 'HEIGHT'
    expect(page).to have_text 'TIMESTAMP'

    within '.block-details' do
      expect(page).to have_text 'Producer'
      expect(page).to have_text 'B62qmfS8M6naWa1jNeZT12jfxLmngSdg2TZzTcz7skt5Czm...'

      expect(page).to have_text 'Total Currency'
    end

    within 'table.transactions' do
      expect(page.all('tbody > tr').size).to eq 29
    end

    within '.block-height' do
      expect(page).to have_text '6079'
    end
  end
end
