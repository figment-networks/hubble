class User < ApplicationRecord
  has_secure_password
  MASQ_TIMEOUT = 10.minutes

  has_many :alert_subscriptions
  has_many :watches, class_name: 'Common::Watch'

  has_many :livepeer_delegator_lists, class_name: 'Livepeer::DelegatorList'

  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  default_scope -> { where.not(deleted: true) }

  # BAKERHUB - will eventually migrate to existing subscription framework
  has_one :telegram_account, class_name: 'Telegram::Account'
  has_many :subscriptions

  scope :with_telegram_account, lambda {
                                  left_joins(:telegram_account).where.not(telegram_accounts: { id: nil, chat_id: nil })
                                }
  scope :with_subscriptions, -> { where.not(subscriptions_count: 0) }

  def self.subscribed_to_baker(baker_address)
    ids = Subscription.where(baker_id: baker_address).pluck(:user_id)
    where(id: ids)
  end

  def subscribed_to_baker?(baker)
    subscriptions.where(record: baker).any?
  end

  def has_telegram_account?
    telegram_account.present? && telegram_account.chat_id.present?
  end
  # /BAKERHUB

  def verified?
    verification_token.nil?
  end

  def subscribed_to?(alertable)
    alert_subscriptions.where(alertable: alertable).exists?
  end

  def update_for_request(ua:, ip:)
    self.last_seen_at = Time.now
    update_details ua: ua, ip: ip
    save
  end

  def update_for_login(ua:, ip:)
    self.last_login_at = Time.now
    self.last_seen_at = Time.now
    update_details ua: ua, ip: ip
    save
  end

  def update_for_signup(ua:, ip:)
    update_details ua: ua, ip: ip
    save
  end

  private

  def update_details(ua:, ip:)
    if ua
      json_ua = JsonUserAgent.new(ua).as_json.to_json
      self.user_agents = [json_ua, *(user_agents || [])].uniq.slice(0, 5)
    end

    if ip
      self.ip_addresses = [ip, *(ip_addresses || [])].uniq.slice(0, 5)
    end
  end
end
