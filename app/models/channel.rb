class Channel < ApplicationRecord
  has_many :channel_users, dependent: :destroy
  has_many :users, through: :channel_users
  has_many :messages, dependent: :destroy

  validates :name, presence: true, uniqueness: true, unless: :is_private

  after_create_commit :broadcast_channel_if_public

  private

  def broadcast_channel_if_public
    return if is_private

    broadcast_append_to "channels_list",
                        target: "public_channels_list",
                        partial: "channels/channel_link",
                        locals: { channel: self, active: false }
  end
end
