# worker to send the webhook to the configured webhook urls
class UserWebhookJob
  include Sidekiq::Job

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user

    user.process_webhook
  end
end
