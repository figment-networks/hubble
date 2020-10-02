class Common::ValidatorEvent < ApplicationRecord
  belongs_to :chainlike, polymorphic: true
  belongs_to :validatorlike, polymorphic: true

  default_scope do
    order('height DESC').order(Arel.sql(%(
    CASE type when 'Common::ValidatorEvents::NConsecutive' then 1
              when 'Common::ValidatorEvents::NOfM' then 2
              when 'Common::ValidatorEvents::VotingPowerChange' then 3
              when 'Common::ValidatorEvents::ActiveSetInclusion' then 4
    end
  )))
  end

  scope :voting_power_change, -> { where(type: 'Common::ValidatorEvents::VotingPowerChange') }
  scope :active_set_inclusion, -> { where(type: 'Common::ValidatorEvents::ActiveSetInclusion') }
  scope :n_of_m, -> { where(type: 'Common::ValidatorEvents::NOfM') }
  scope :n_consecutive, -> { where(type: 'Common::ValidatorEvents::NConsecutive') }

  after_create :tweet_maybe

  def kind_string
    self.class.name.demodulize.underscore
  end

  def block
    chainlike.blocks.find_by(height: height) ||
      chainlike.class.name.deconstantize.constantize::Block.stub(chainlike, height)
  end

  def to_partial_path
    self.class.name.underscore
  end

  private

  def tweet_maybe
    return if !chainlike.has_twitter_config?

    begin
      r = Router.new
      msg = "#{twitter_msg} - #{r.namespaced_path('event', self, chain: chainlike, full: true)}"

      tc = chainlike.twitter_events_config
      client = Twitter::REST::Client.new do |config|
        config.consumer_key = tc['consumer_key']
        config.consumer_secret = tc['consumer_secret']
        config.access_token = tc['access_token']
        config.access_token_secret = tc['access_secret']
      end

      if Rails.env.production?
        client.update(msg)
      else
        puts "\n############ TWEET ############\n#{msg}\n\n"
      end
    rescue StandardError
      Rollbar.error($!, "Could not tweet validator event #{id}")
    end
  end
end

require_dependency 'common/validator_events/active_set_inclusion'
require_dependency 'common/validator_events/voting_power_change'
require_dependency 'common/validator_events/n_consecutive'
require_dependency 'common/validator_events/n_of_m'
