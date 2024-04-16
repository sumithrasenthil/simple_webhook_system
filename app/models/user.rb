class User < ApplicationRecord
  MAX_EMAIL_LENGTH = 120

  validates :name, :email, :phone_number, presence: true
  validates :email, uniqueness: true, length: { maximum: MAX_EMAIL_LENGTH }
  validate :valid_email_format

  after_save_commit :trigger_webhook

  private

  def trigger_webhook
    UserWebhookJob.perform_async(id, self.persisted? ? 'create' : 'update')
  end

  def valid_email_format
    errors.add(:email, 'is invalid') unless email&.match?(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
  end
end
