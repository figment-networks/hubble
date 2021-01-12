class Common::SyncChecker
  attr_reader :network, :notifier

  def initialize(network, notifier)
    @notifier = notifier
    @network = network
  end

  def out_of_sync?(chain)
    Time.zone.parse(chain.last_sync_time.to_s).between?(2.hours.ago, 1.hour.ago)
  end

  def run
    network.titleize.constantize::Chain.enabled.find_each do |chain|
      if out_of_sync?(chain) && Rails.env.production?
        puts "#{network.capitalize} - #{chain.slug} is out of sync.  Attempting to notify Slack."
        notifier.post(attachments: [sync_error(chain)])
      else
        puts "#{network.capitalize} - #{chain.slug} looks healthy."
      end
    end
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
