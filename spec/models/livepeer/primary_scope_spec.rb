require 'rails_helper'

RSpec.describe Livepeer::Chain do
  let!(:chains) { create_list(:livepeer_chain, 3, primary: true) }
  include_examples "is primary scoped"
end
