namespace :tezos do
  task cycle_report: :environment do
    Tezos::Chain.enabled.each do |chain|
      TaskLock.with_lock!(:digests, "tezos-#{chain.slug}") do
        Tezos::CycleReportService.execute(chain)
      end
    end
  end
end
