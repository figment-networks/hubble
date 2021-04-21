require 'rails_helper'

RSpec.describe Skale::Chain do
  let!(:chains) { create_list(:skale_chain, 3, primary: true) }

  include_examples 'is primary scoped'
end
