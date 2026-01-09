class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :message

  validates :recipient, presence: true
  validates :actor, presence: true
end
