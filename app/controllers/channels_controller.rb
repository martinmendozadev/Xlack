class ChannelsController < ApplicationController
  def index
    @channels = current_user.channels

    @active_channel = @channels.first

    if @active_channel
      @messages = @active_channel.messages
                                 .where(parent_id: nil)
                                 .includes(:user)
                                 .order(created_at: :asc)
    else
      @messages = []
    end
  end
end
