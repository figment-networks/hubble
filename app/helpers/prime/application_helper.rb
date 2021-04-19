module Prime::ApplicationHelper
  PAGE_TITLE_PREFIX = 'Prime by Figment'.freeze
  NETWORK_EVENTS_LIMIT = 25

  def prime_js_namespace
    obj = {
      # data
      mode: [],
      seed: {},

      # class namespaces
      Prime: {}
    }

    javascript_tag "window.App = #{obj.to_json.html_safe};"
  end

  def prime_page_title
    if @page_title
      return "#{PAGE_TITLE_PREFIX} | #{@page_title}"
    end

    PAGE_TITLE_PREFIX
  end

  def enabled_networks
    @enabled_networks ||= decorate_networks(Prime::Network.enabled.order(name: :asc))
  end

  def testing_networks
    @testing_networks ||= Prime::Network.testing
  end

  def user_accounts
    @user_accounts ||= @current_user.prime_accounts.on_enabled_networks.includes([:network]).map do |account|
      "Prime::#{account.network.name.capitalize}::AccountDecorator".constantize.new(account)
    end
  end

  def user_networks
    @user_networks ||= decorate_networks(Prime::Network.find(@current_user.prime_accounts.distinct.pluck(:prime_network_id)))
  end

  def user_rewards
    @user_rewards ||= user_accounts.map(&:rewards).flatten.sort_by!(&:time).reverse!
  end

  def user_network_rewards(network)
    user_rewards.select { |reward| reward.account.network.name == network.name }.sum(&:amount) / (10 ** network.primary.reward_token_factor)
  end

  def network_events
    @network_events ||= begin
      events = []
      enabled_networks.each do |network|
        events += network.events!
      end
      events.sort_by!(&:update_date).reverse![0, [events.length, NETWORK_EVENTS_LIMIT].min - 1]
    end
  end

  def calendar_events
    @calendar_events ||= network_events.select { |event| event.event_date }
  end

  def figment_validators
    @figment_validators ||= get_validators(enabled_networks)
  end

  def user_validators
    @user_validators ||= get_validators(user_networks)
  end

  def active_nav_option(path)
    current_page?(path) ? 'active' : ''
  end

  private

  def get_validators(networks)
    validators = []
    networks.each do |network|
      validators += network.figment_validators!
    end
    validators
  end

  def decorate_networks(networks)
    networks.map do |network|
      if network.token_metrics!.success
        Prime::NetworkDecorator.new(network)
      else
        flash[:error] = 'We are experiencing issues with our data services, some information is currently unavailable.'
        Prime::FailedNetworkDecorator.new(network)
      end
    end
  end
end
