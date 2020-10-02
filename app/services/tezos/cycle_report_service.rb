require 'indexer/resources/cycle'

module Tezos
  class CycleReportService
    # TODO: once the indexer supports multiple chains, update this to get the latest cycle
    # for the provided chain
    def self.execute(_chain)
      cycle  = Indexer::Cycle.retrieve('latest_completed')
      report = Tezos::CycleReport.find_by(cycle_number: cycle.number)

      if report.nil?
        puts "Generating cycle report emails for Cycle #{cycle.number}"
        Tezos::CycleReport.create(cycle_number: cycle.number)
      else
        puts "Already generated cycle report emails for Cycle #{cycle.number}"
      end
    end
  end
end
