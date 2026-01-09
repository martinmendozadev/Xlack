class Message < ApplicationRecord
  belongs_to :user
  belongs_to :channel

  belongs_to :parent, class_name: "Message", optional: true
  has_many :replies, class_name: "Message", foreign_key: "parent_id", dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :content, presence: true

  after_create_commit :broadcast_message
  after_create :notify_mentions

  private

  def broadcast_message
    if parent_id.nil?
      broadcast_append_to channel,
                          target: "messages",
                          partial: "messages/message",
                          locals: { message: self }

      broadcast_remove_to channel, target: "no_messages_placeholder"

    else
      broadcast_append_to parent,
                          target: "thread_messages_#{parent.id}",
                          partial: "messages/message",
                          locals: { message: self }

      broadcast_replace_to channel,
                           target: "message_#{parent.id}",
                           partial: "messages/message",
                           locals: { message: parent }
    end
  end

  def notify_mentions
    mentioned_names = content.scan(/@(\w+)/).flatten.uniq

    mentioned_names.each do |name|
      user = User.find_by(username: name)

      if user && user != self.user && channel.users.include?(user)

        Notification.create(
          recipient: user,
          actor: self.user,
          message: self
        )
      end
    end
  end
end
