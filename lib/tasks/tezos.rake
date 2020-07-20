namespace :tezos do
  task cycle_report: :environment do
    Tezos::Chain.enabled.each do |chain|
      Tezos::CycleReportService.execute(chain)
    end
  end

  task detect_events: :environment do
    Tezos::Chain.enabled.each do |chain|
      Tezos::EventDetectionService.new.detect_events!(chain)
    end
  end
end
