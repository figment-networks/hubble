RSpec.shared_examples 'is primary scoped' do
  subject { described_class.all.select { |chain| chain.primary? } }

  it 'has a single primary chain' do
    expect(subject.length == 1)
  end
end

RSpec.shared_examples 'default token display' do
  it 'returns the DEFAULT_TOKEN_DISPLAY' do
    expect(chain.token_display).to eq described_class::DEFAULT_TOKEN_DISPLAY
  end
end
