class Livepeer::Queries::PoolReportQuery < Livepeer::Queries::ReportQuery
  private

  def group_by_orchestrator(relation)
    relation.group(:orchestrator_address).select(self.class::FIELDS)
  end

  def group_by_round_and_orchestrator(relation)
    relation.
      group(:round_number, :orchestrator_address).
      select(self.class::FIELDS).
      order(:round_number)
  end
end
