namespace :network_data do
  task all: :environment do
    %w[cosmos kava terra emoney iris].each do |network|
      Rake::Task["network_data:#{network}"].invoke
    end
  end

  %w[cosmos kava terra emoney iris].each do |network|
    task "#{network.to_sym}": :environment do
      $stdout.sync = true
      network.titleize.constantize::Chain.enabled.alive.has_synced.find_each do |chain|
        puts "Fetching network data for #{network} -- #{chain.name}"

        begin
          syncer = chain.syncer
        rescue Cosmoslike::SyncBase::CriticalError
          Rails.logger.error $!.message
          puts $!.message
          puts "Failed to get network data for #{network} -- #{chain.name} ..."
          next
        end

        fetcher = Cosmoslike::NetworkDataFetcher.new(chain, syncer)

        begin
          print "\t Rewards Rate...\t"
          rewards_rate = fetcher.rewards_rate
          puts rewards_rate.to_s
          chain.update rewards_rate: rewards_rate
        rescue Cosmoslike::NetworkDataFetcher::FetchError
          Rails.logger.error $!.message
          puts "\tRewards Rate did not update: #{$!.message}"
        end

        begin
          print "\t Daily Rewards...\t"
          daily_rewards = fetcher.daily_rewards
          puts daily_rewards.to_s
          chain.update daily_rewards: daily_rewards
        rescue Cosmoslike::NetworkDataFetcher::FetchError
          Rails.logger.error $!.message
          puts "\tDaily Rewards did not update: #{$!.message}"
        end

        begin
          print "\t Staking Participation...\t"
          staking_participation = fetcher.staking_participation
          puts staking_participation.to_s
          chain.update staking_participation: staking_participation
        rescue Cosmoslike::NetworkDataFetcher::FetchError
          Rails.logger.error $!.message
          puts "\tStaking Participation did not update: #{$!.message}"
        end
      end
    end
  end
end
