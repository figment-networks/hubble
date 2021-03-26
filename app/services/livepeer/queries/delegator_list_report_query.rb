class Livepeer::Queries::DelegatorListReportQuery < Livepeer::Queries::ReportQuery
  def initialize(delegator_list, params)
    super(delegator_list.chain, params)

    @delegator_list = delegator_list
  end

  private

  attr_reader :delegator_list

  def filter_by_delegators(relation)
    relation.where(delegator_address: delegator_list.addresses)
  end

  def group_by_delegator(relation)
    relation.group(:delegator_address).select(self.class::FIELDS)
  end

  def group_by_round_and_delegator(relation)
    relation.
      group(:round_number, :delegator_address).
      select(self.class::FIELDS).
      order(:round_number)
  end
end
