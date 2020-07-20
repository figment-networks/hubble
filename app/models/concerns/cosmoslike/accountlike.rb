module Cosmoslike::Accountlike
  extend ActiveSupport::Concern

  included do |klass|
    namespace = klass.name.deconstantize.constantize

    belongs_to :chain, class_name: "#{namespace}::Chain"
    belongs_to :validator, class_name: "#{namespace}::Validator", optional: true

    has_many :governance_deposits, class_name: "#{namespace}::Governance::Deposit"
    has_many :governance_votes, class_name: "#{namespace}::Governance::Vote"

    validates :address, allow_blank: false, presence: true, uniqueness: { scope: :chain }
  end

  def to_param; address; end
end
