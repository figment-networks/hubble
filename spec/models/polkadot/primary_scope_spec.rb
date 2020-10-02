require 'rails_helper'

RSpec.describe Polkadot::Chain do
  let!(:chains) { create_list(:polkadot_chain, 3, primary: true) }

  include_examples 'is primary scoped'
end
