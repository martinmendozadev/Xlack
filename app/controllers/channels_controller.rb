class ChannelsController < ApplicationController
  def index
    @public_channels = current_user.channels.where(is_private: false)
    @direct_messages = current_user.channels.where(is_private: true)

    if params[:id]
      @active_channel = Channel.find(params[:id])
    else
      @active_channel = @public_channels.first || @direct_messages.first
    end

    if @active_channel && !@active_channel.users.include?(current_user)
      redirect_to root_path, alert: "No tienes acceso."
      return
    end

    if @active_channel
      @messages = @active_channel.messages
                                 .where(parent_id: nil)
                                 .includes(:user)
                                 .order(created_at: :asc)
    else
      @messages = []
    end
  end

  def show
    index
    render :index
  end
end
