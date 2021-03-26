require 'features_helper'

describe 'Livepeer Orchestrator Pool Reports', livepeer: :factory do
  include_context 'Livepeer pool data'

  let(:end_date) { rounds[1].initialized_at.to_date }
  let(:start_date) { rounds[0].initialized_at.to_date }

  it 'generates a round report' do
    visit "/livepeer/chains/#{chains[0].slug}"

    click_link 'Generate report'

    expect(page).to have_content('Generate a report')
    expect(page).to have_content('ORCHESTRATOR POOL REPORT')

    choose 'Round'

    select '1000', from: 'Round number'

    click_button 'Generate'

    expect(page).to have_content('Orchestrator Pool Report')

    expect(page).to have_content('BDE0750C5C3BD4AFDB495E26B790F7771CCD8D22')
    expect(page).to have_content('100 LPT 10 LPT')

    expect(page).to have_content('F70F722EF2B093B253FD237AA8E32792FE1B64A8')
    expect(page).to have_content('200 LPT 20 LPT')

    expect(page).to have_content("ROUND\n1000")
  end

  it 'generates a date range report' do
    visit "/livepeer/chains/#{chains[0].slug}"

    click_link 'Generate report'

    expect(page).to have_content('Generate a report')
    expect(page).to have_content('ORCHESTRATOR POOL REPORT')

    choose 'Date range'

    find('#start-date').set(start_date)
    find('#end-date').set(end_date)

    click_button 'Generate'

    expect(page).to have_content('Orchestrator Pool Report')

    expect(page).to have_content('BDE0750C5C3BD4AFDB495E26B790F7771CCD8D22')
    expect(page).to have_content('300 LPT 40 LPT')

    expect(page).to have_content('F70F722EF2B093B253FD237AA8E32792FE1B64A8')
    expect(page).to have_content('400 LPT 60 LPT')

    expect(page).to have_content("Start date: #{start_date}")
    expect(page).to have_content("End date: #{end_date}")
  end
end
