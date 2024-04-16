# model where the webhook details will be stored like end_point, secret, event_type and webhook active
class WebhookDetail < ApplicationRecord
  EVENT_TYPE = { 'Create' => 1, 'Update' => 2, 'Destroy' => 3 }.freeze
  validates :event_type, presence: true, inclusion: { in: EVENT_TYPE.keys, message: 'invalid event_type' }
  validates :end_point, :secret, presence: true

  scope :active, -> { where(active: true) }
  scope :create_or_update_event, -> { where(event_type: [EVENT_TYPE['Create'], EVENT_TYPE['Create']]) }

  def event_type
    EVENT_TYPE.invert[read_attribute :event_type]
  end

  def event_type=(val)
    write_attribute :event_type, EVENT_TYPE[val]
  end
end
