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
      redirect_to root_path, alert: t("channels.access_denied")
      return
    end

    if @active_channel
      membership = @active_channel.channel_users.find_by(user: current_user)
      membership&.update(last_read_at: Time.current)

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
  def new
    @channel = Channel.new
  end

  def create
    @channel = Channel.new(channel_params)
    @channel.is_private = false

    if @channel.save
      ChannelUser.create(user: current_user, channel: @channel)

      redirect_to channel_path(@channel), notice: t("channels.created_successfully")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def channel_params
    params.require(:channel).permit(:name)
  end
end
