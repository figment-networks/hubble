require 'rails_helper'

RSpec.describe Iris::Chain do
  let!(:chains) { create_list(:iris_chain, 3, primary: true) }
  include_examples "is primary scoped"
end
