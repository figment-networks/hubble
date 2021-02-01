require 'rails_helper'

describe Avalanche::Account do
  let(:account) { described_class.new(attributes) }
  let(:attributes) do
    {
      'balance' => '0',
      'unlocked' => '0',
      'lockedStakeable' => '0',
      'lockedNotStakeable' => '0'
    }
  end

  it 'Converts all values to ints correctly' do
    expect(account.balance).to be_a Integer
    expect(account.unlocked).to be_a Integer
    expect(account.locked_stakeable).to be_a Integer
    expect(account.locked_not_stakeable).to be_a Integer
  end
end
