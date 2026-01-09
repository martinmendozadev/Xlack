class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :message

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  validates :recipient, presence: true
  validates :actor, presence: true

  after_create_commit do
    broadcast_replace_to "notifications_#{recipient_id}",
                         target: "notifications_link",
                         partial: "notifications/sidebar_link",
                         locals: { unread_count: recipient.notifications.unread.count }
  end
end
