shared_examples_for 'block view' do |chain_name|
  scenario 'visiting block view', :vcr do
    visit "/#{chain_name}/chains/#{chain.slug}/blocks/#{block_id}"

    expect(page).to have_content(chain.network_name)
    expect(page).to have_content(block_id)
    expect(page).to have_content('Transactions')
    expect(page).to have_content('Validators')
    expect(page).to have_content(/Timestamp/i)
  end
end
