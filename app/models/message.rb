class Message < ApplicationRecord
  belongs_to :user
  belongs_to :channel

  belongs_to :parent, class_name: "Message", optional: true
  has_many :replies, class_name: "Message", foreign_key: "parent_id", dependent: :destroy

  validates :content, presence: true

  after_create_commit do
    broadcast_append_to channel,
                        target: "messages",
                        partial: "messages/message",
                        locals: { message: self }
  end
end
