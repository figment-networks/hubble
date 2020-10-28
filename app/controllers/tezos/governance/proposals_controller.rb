require 'indexer/resources/proposal'
require 'indexer/resources/voting_period'
require 'indexer/resources/ballot'

class Tezos::Governance::ProposalsController < Tezos::BaseController
  def show
    @proposal = Indexer::Proposal.retrieve(params['id'])
    selected_period_id = params['voting_period'].presence || @proposal.start_period
    @selected_period = Indexer::VotingPeriod.retrieve(selected_period_id)
    @selected_period_votes = Indexer::Ballot.ballots_by_period(@selected_period.id)

    if @proposal.is_active?
      @current_period = Indexer::VotingPeriod.latest
      @current_period_votes = Indexer::Ballot.ballots_by_period(@current_period.id)
      if @current_period.period_type.in?(%w[testing_vote promotion_vote])
        @current_tally_result = Tezos::VotingPeriodTallyDecorator.new(@current_period, @current_period_votes)
      elsif @current_period.period_type == 'proposal'
        @current_tally_result = Tezos::PropPeriodTallyDecorator.new(@current_period, @current_period_votes)
      end
    end

    if @selected_period.period_type.in?(%w[testing_vote promotion_vote])
      @selected_period_tally_result = Tezos::VotingPeriodTallyDecorator.new(@selected_period, @selected_period_votes)
    elsif @selected_period.period_type == 'proposal'
      @selected_period_tally_result = Tezos::PropPeriodTallyDecorator.new(@selected_period, @selected_period_votes)
    end

    render template: 'tezos/governance/proposal'
  end
end
