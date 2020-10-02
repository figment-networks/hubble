require 'rails_helper'

RSpec.describe Oasis::Chain do
  let!(:chains) { create_list(:oasis_chain, 3, primary: true) }

  include_examples 'is primary scoped'
end
