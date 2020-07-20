module Cosmoslike::Governance::Depositlike
  extend ActiveSupport::Concern

  included do |klass|
    namespace = klass.name.split('::').first.constantize

    belongs_to :account, class_name: "#{namespace}::Account"
    belongs_to :proposal, class_name: "#{namespace}::Governance::Proposal"
  end
end
