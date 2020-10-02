require 'features_helper'

describe 'tezos governance' do
  let!(:chain) { create(:tezos_chain) }
  let(:promoted_proposal_id) { 'PsCARTHAGazKbHtnKfLzQg3kms52kSRpgnDY982a9oYsSXRLQEb' }
  let(:promoted_proposal_title) { 'Carthage 2.0' }
  let(:active_proposal_id) { 'PsDELPH1Kxsxt8f9eWbxQeRxkjfbxoqM52jvs5Y5fBxWWh4ifpo' }
  let(:active_proposal_title) { 'Delphi' }

  it 'promoted proposal details', :vcr do
    visit '/tezos/governance'

    click_link(promoted_proposal_title)
    expect(page).to have_content(promoted_proposal_id)
    expect(page).to have_content(promoted_proposal_title)
    expect(page).to have_content('Proposal successfully promoted.')
    expect(page).to have_content('Info')
    expect(page).to have_content('Tallying Procedure')

    click_button('SHOW') # description
    expect(page).to have_content('Features')
    expect(page).to have_content('Explanation Post')
    expect(page).to have_content('Invoice')

    click_button('Evaluation Period')
    expect(page).to have_content('YAY')
    expect(page).to have_content('NAY')
    expect(page).to have_content('PASS')
    expect(page).to have_content('supermajority reached')

    click_button('Testing Period')
    expect(page).to have_content('Testing period - no voting')

    click_button('Promotion Period')
    expect(page).to have_content('YAY')
    expect(page).to have_content('NAY')
    expect(page).to have_content('PASS')
  end

  it 'active proposal details', :vcr do
    visit '/tezos/governance/proposals/PsDELPH1Kxsxt8f9eWbxQeRxkjfbxoqM52jvs5Y5fBxWWh4ifpo'

    expect(page).to have_content('In proposal period voting.')

    click_button('Evaluation Period')
    expect(page).to have_content('50%')
    expect(page).to have_content('42136 of 84105 rolls have voted.')
  end
end
