require 'rails_helper'

RSpec.describe Avalanche::Chain do
  let!(:chains) { create_list(:avalanche_chain, 3, primary: true) }

  include_examples 'is primary scoped'
end
