class Channel < ApplicationRecord
  has_many :channel_users, dependent: :destroy
  has_many :users, through: :channel_users
  has_many :messages, dependent: :destroy

  validates :name, presence: true, uniqueness: true, unless: :is_private

  after_create_commit :broadcast_channel_if_public

  def self.find_or_create_dm(user_a, user_b)
    dm_channel = user_a.channels.where(is_private: true).find do |channel|
      channel.users.include?(user_b)
    end

    dm_channel ||= create_dm(user_a, user_b)
  end

  private

  def broadcast_channel_if_public
    return if is_private

    broadcast_append_to "channels_list",
                        target: "public_channels_list",
                        partial: "channels/channel_link",
                        locals: { channel: self, active: false },
                        user: nil
  end

  def self.create_dm(user_a, user_b)
    transaction do
      channel = create!(name: "dm-#{[ user_a.id, user_b.id ].sort.join('-')}", is_private: true)

      ChannelUser.create!(channel: channel, user: user_a)
      ChannelUser.create!(channel: channel, user: user_b)

      channel
    end
  end
end
