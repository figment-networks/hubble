module Cosmoslike::Governance::Votelike
  extend ActiveSupport::Concern

  included do |klass|
    namespace = klass.name.split('::').first.constantize

    belongs_to :account, class_name: "#{namespace}::Account"
    belongs_to :proposal, class_name: "#{namespace}::Governance::Proposal"

    validates :option, allow_blank: false, presence: true
  end

  def short_option
    case option.downcase
    when 'nowithveto' then 'veto'
    else option
    end
  end
end
