module Oasis
  class Delegation < Common::Resource
    field :validator_uid
    field :delegator_uid
    field :shares
    field :status

    def initialize(attr, status = 'bonded')
      super(attr)
      @status = status
    end
  end
end
