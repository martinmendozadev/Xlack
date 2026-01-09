class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :message

  validates :user_id, uniqueness: { scope: [ :message_id, :emoji ] }

  after_commit :broadcast_reaction_update

  private

  def broadcast_reaction_update
    broadcast_replace_to message.channel,
                         target: "reactions_message_#{message.id}",
                         partial: "reactions/list",
                         locals: { message: message }
  end
end
