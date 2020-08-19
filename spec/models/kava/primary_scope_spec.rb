require 'rails_helper'

RSpec.describe Kava::Chain do
  let!(:chains) { create_list(:kava_chain, 3, primary: true) }
  include_examples "is primary scoped"
end
