require 'rails_helper'

RSpec.describe Common::CsvExporter do
  subject { described_class.new(records, attributes) }

  let(:records) do
    [
      create(:livepeer_round, number: 1, mintable_tokens: '17817.375673954043909133'),
      create(:livepeer_round, number: 2, mintable_tokens: '17859.737930247454986706')
    ]
  end

  let(:attributes) { %i[number mintable_tokens] }

  it 'generates CSV data' do
    result = CSV.parse(subject.call)

    expect(result[0]).to eq(['Number', 'Mintable Tokens'])
    expect(result[1]).to eq(['1', '17817.375673954043909133'])
    expect(result[2]).to eq(['2', '17859.737930247454986706'])
  end
end
