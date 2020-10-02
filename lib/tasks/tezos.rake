namespace :tezos do
  task cycle_report: :environment do
    Tezos::Chain.enabled.each do |chain|
      TaskLock.with_lock!(:digests, "tezos-#{chain.slug}") do
        Tezos::CycleReportService.execute(chain)
      end
    end
  end

  task detect_events: :environment do
    Tezos::Chain.enabled.each do |chain|
      TaskLock.with_lock!(:alerts, "tezos-#{chain.slug}") do
        Tezos::EventDetectionService.new.detect_events!(chain)
      end
    end
  end
end
