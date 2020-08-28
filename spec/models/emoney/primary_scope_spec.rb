require 'rails_helper'

RSpec.describe Emoney::Chain do
  let!(:chains) { create_list(:emoney_chain, 3, primary: true) }
  include_examples "is primary scoped"
end
