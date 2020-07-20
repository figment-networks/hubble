require 'features_helper'

feature 'tezos governance' do
  let!(:chain) { create(:tezos_chain) }
  let(:proposal_id) { 'PsCARTHAGazKbHtnKfLzQg3kms52kSRpgnDY982a9oYsSXRLQEb' }
  let(:proposal_title) { 'Carthage 2.0' }
  
  scenario 'proposal details', :vcr do
    visit "/tezos/governance"

    click_link(proposal_title)
    expect(page).to have_content(proposal_id)
    expect(page).to have_content(proposal_title)

    expect(page).to have_content('Info')
    expect(page).to have_content('Tallying Procedure')

    click_button('SHOW') #description
    expect(page).to have_content('Features')
    expect(page).to have_content('Explanation Post')
    expect(page).to have_content('Invoice')

    click_button('Evaluation Period')
    expect(page).to have_content('YAY')
    expect(page).to have_content('NAY')
    expect(page).to have_content('PASS')

    click_button('Testing Period')
    
    click_button('Promotion Period')
    expect(page).to have_content('YAY')
    expect(page).to have_content('NAY')
    expect(page).to have_content('PASS')
  end
end
