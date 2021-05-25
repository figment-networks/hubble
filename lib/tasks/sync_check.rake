require 'slack-notifier'

namespace :health do
  task check_chains: :environment do
    notifier = Slack::Notifier.new(Rails.application.secrets.slack_synccheck_webhook_url,
                                   username: 'SyncChecker')
    Common::SyncChecker.run_all(notifier)
  end
end
