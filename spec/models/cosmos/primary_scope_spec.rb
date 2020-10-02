require 'rails_helper'

RSpec.describe Cosmos::Chain do
  let!(:chains) { create_list(:cosmos_chain, 3, primary: true) }

  include_examples 'is primary scoped'
end
