module Skale
  class Status < Common::Resource
    field :success, default: true

    alias success? success

    def self.failed
      new({ 'success' => false })
    end
  end
end
