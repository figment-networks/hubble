RSpec.shared_examples 'is primary scoped' do
  subject { described_class.all.select { |chain| chain.primary? } }

  it 'has a single primary chain' do
    expect(subject.length == 1)
  end
end
