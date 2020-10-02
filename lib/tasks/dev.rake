namespace :dev do
  task skip_to_now: :environment do
    exit(1) if !Rails.env.development?
    [Cosmos, Kava, Iris, Terra, Emoney].each do |network|
      network::Chain.enabled.each do |chain|
        chain.skip_to_now!
      end
    end
  end
end

namespace :test do
  namespace :mail do
    namespace :alert do
      task daily: :environment do
        # grab a random sub, random events
        # and a random date, and send a daily alert
        AlertMailer.with(
          sub: AlertSubscription.order('RANDOM()').first,
          events: Common::ValidatorEvent.order('RANDOM()').take(5),
          date: Time.now - (rand * 5).days
        ).daily.deliver_now
      end

      task instant: :environment do
        # grab a random sub, random events
        # and send an instant alert
        AlertMailer.with(
          sub: AlertSubscription.order('RANDOM()').first,
          events: Common::ValidatorEvent.order('RANDOM()').take(5)
        ).instant.deliver_now
      end
    end

    namespace :user do
      task confirm: :environment do
        user = User.order('RANDOM()').first
        user.verification_token = SecureRandom.hex
        UserMailer.with(user: user).confirm.deliver_now
      end

      task forgot_password: :environment do
        user = User.order('RANDOM()').first
        user.password_reset_token = SecureRandom.hex
        UserMailer.with(user: user).forgot_password.deliver_now
      end
    end
  end
end
