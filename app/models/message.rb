class Message < ApplicationRecord
  belongs_to :user
  belongs_to :channel

  belongs_to :parent, class_name: "Message", optional: true
  has_many :replies, class_name: "Message", foreign_key: "parent_id", dependent: :destroy

  validates :content, presence: true

  after_create_commit :broadcast_message

  private

  def broadcast_message
    if parent_id.nil?
      broadcast_append_to channel,
                          target: "messages",
                          partial: "messages/message",
                          locals: { message: self }
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
end
