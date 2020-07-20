require "indexer/resources/proposal"
require "indexer/resources/voting_period"

class Tezos::Governance::MainController < Tezos::BaseController
  def index
    @proposals = Indexer::Proposal.list.sort_by { |p| -p.start_period }
    @current_period = Indexer::VotingPeriod.latest
    render template: 'tezos/governance/index'
  end
end
