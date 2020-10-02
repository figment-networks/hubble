require 'rails_helper'

RSpec.describe Terra::Chain do
  let!(:chains) { create_list(:terra_chain, 3, primary: true) }

  include_examples 'is primary scoped'
end
