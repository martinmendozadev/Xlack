class ReactionsController < ApplicationController
  def create
    @message = Message.find(params[:message_id])
    emoji = params[:emoji]

    existing_reaction = @message.reactions.find_by(user: current_user, emoji: emoji)

    if existing_reaction
      existing_reaction.destroy
    else
      @message.reactions.create(user: current_user, emoji: emoji)
    end

    head :ok
  end
end
