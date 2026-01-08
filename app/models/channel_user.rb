class ChannelUser < ApplicationRecord
  belongs_to :user
  belongs_to :channel

  def has_unread_messages?
    return true if last_read_at.nil? && channel.messages.any?

    last_message = channel.messages.where(parent_id: nil).last
    return false unless last_message

    last_message.created_at > last_read_at
  end
end
