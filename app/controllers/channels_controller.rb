class ChannelsController < ApplicationController
  def index
    first_channel = current_user.channels.first

    if first_channel
      redirect_to channel_path(first_channel)
    else
      render plain: t('channels.no_active_channel')
    end
  end

  def show
    @channels = current_user.channels
    begin
      @active_channel = Channel.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: t('channels.channel_not_found')
      return
    end

    unless @channels.include?(@active_channel)
      redirect_to root_path, alert: t('channels.no_access_to_channel')
      return
    end

    @messages = @active_channel.messages
                               .where(parent_id: nil)
                               .includes(:user)
                               .order(created_at: :asc)

    render :index
  end
end
