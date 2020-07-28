require "indexer/resources/proposal"
require "indexer/resources/voting_period"
require "indexer/resources/ballot"

class Tezos::Governance::ProposalsController < Tezos::BaseController
  def show
    @proposal = Indexer::Proposal.retrieve(params['id'])
    period_id = params['voting_period'].present? ? params['voting_period'] : @proposal.start_period
    @voting_period = Indexer::VotingPeriod.retrieve(period_id)
    @votes = Indexer::Ballot.ballots_by_period(@voting_period.id)
    if @proposal.is_active?
      @current_period = Indexer::VotingPeriod.latest
    end
    if @voting_period.period_type.in?(%w[testing_vote promotion_vote])
      @tally_result = Tezos::VotingPeriodTallyDecorator.new(@voting_period, @votes)
    elsif @voting_period.period_type == 'proposal'
      @tally_result = Tezos::PropPeriodTallyDecorator.new(@voting_period, @votes)
    end

    render template: 'tezos/governance/proposal'
  end
end
