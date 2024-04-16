class UserWebhookJob
  include Sidekiq::Job

  def perform(user_id, event)
    user = User.find_by(id: user_id)
    return unless user
    
  end
end
