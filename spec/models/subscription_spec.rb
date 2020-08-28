require "rails_helper"

RSpec.describe Subscription do
  it "is invalid for a duplicate baker_id" do
    user = create(:user)
    baker_id = "asdf123"
    sub1 = described_class.create(user: user, baker_id: baker_id)
    sub2 = described_class.new(user: user, baker_id: baker_id)

    expect(sub2).not_to be_valid
    expect(sub2.errors.details[:baker_id][0][:error]).to eq :taken
  end
end
