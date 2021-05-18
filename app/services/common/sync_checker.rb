class Common::SyncChecker
  DEFAULT_SYNC_LIMIT_HOURS = 1

  NETWORKS = [
    { network: 'cosmos' },
    { network: 'terra' },
    { network: 'iris' },
    { network: 'kava' },
    { network: 'emoney' },
    { network: 'livepeer' },
    { network: 'polkadot', sync_limit_hours: 2 },
    { network: 'near' },
    { network: 'oasis' },
    { network: 'tezos' },
    { network: 'celo' },
    { network: 'mina' },
    { network: 'avalanche' }
  ].freeze

  attr_reader :network, :notifier, :sync_limit_hours

  def initialize(network, sync_limit_hours, notifier)
    @notifier = notifier
    @network = network
    @sync_limit_hours = sync_limit_hours
  end

  def run
    network.titleize.constantize::Chain.enabled.find_each do |chain|
      if out_of_sync?(chain) && Rails.env.production?
        Rollbar.error("#{network.capitalize} - #{chain.slug} is out of sync. Attempting to notify Slack.")
        notifier.post(attachments: [sync_error(chain)])
      end
    end
  rescue StandardError => error
    Rollbar.error(error) if Rails.env.production?
  end

  def self.run_all(notifier)
    NETWORKS.each do |network|
      new(network[:network], network[:sync_limit_hours] || DEFAULT_SYNC_LIMIT_HOURS, notifier).run
    end
  end

  private

  def out_of_sync?(chain)
    Time.zone.parse(chain.last_sync_time.to_s).between?((sync_limit_hours + 1).hours.ago, sync_limit_hours.hour.ago)
  end

  def sync_error(chain)
    {
      title: 'Sync Error',
      text: "#{network.capitalize} - #{chain.slug} hasn't synced in at least 60 minutes.",
      color: 'danger',
      "actions": [
        {
          "text": "Check #{network.capitalize}",
          "type": 'button',
          "url": chain_link_generator(chain),
          "style": 'danger'
        }
      ]
    }
  end

  def chain_link_generator(chain)
    router = Router.new
    router.namespaced_path(chain: chain, full: true)
  end
end
