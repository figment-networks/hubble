require 'rails_helper'

RSpec.describe Tezos::Chain do
  let!(:chains) { create_list(:tezos_chain, 3, primary: true) }

  include_examples 'is primary scoped'
end
