class Message < ApplicationRecord
  belongs_to :user
  belongs_to :channel

  belongs_to :parent, class_name: "Message", optional: true
  has_many :replies, class_name: "Message", foreign_key: "parent_id", dependent: :destroy

  validates :content, presence: true
end
