class User < ApplicationRecord
  include WebHook
  MAX_EMAIL_LENGTH = 120

  validates :name, :email, :phone_number, presence: true
  validates :email, uniqueness: true, length: { maximum: MAX_EMAIL_LENGTH }
  validate :valid_email_format

  after_save_commit :trigger_webhook

  def process_webhook
    data = to_webhook_data
    WebhookDetail.active.create_or_update_event.find_each do |details|
      WebHook.send(details, data)
    end
  end

  private

  def valid_email_format
    errors.add(:email, 'is invalid') unless email&.match?(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
  end

  def trigger_webhook
    UserWebhookJob.perform_async(id)
  end

  def to_webhook_data
    attributes.slice(*User.column_names).merge(
      created_at: created_at.strftime('%Y-%m-%d %H:%M:%S'),
      updated_at: updated_at.strftime('%Y-%m-%d %H:%M:%S')
    )
  end
end
