require 'slack-notifier'

namespace :health do
  task check_chains: :environment do
    %w[cosmos terra iris kava emoney livepeer polkadot].each do |network|
      notifier = Slack::Notifier.new(Rails.application.secrets.slack_synccheck_webhook_url,
                                     username: 'SyncChecker')
      Common::SyncChecker.new(network, notifier).run
    end
  end
end
