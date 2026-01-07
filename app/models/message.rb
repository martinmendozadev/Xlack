class Message < ApplicationRecord
  belongs_to :user
  belongs_to :channel
  belongs_to :parent
end
