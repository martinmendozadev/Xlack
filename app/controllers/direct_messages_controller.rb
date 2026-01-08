class DirectMessagesController < ApplicationController
  def new
    @users = User.where.not(id: current_user.id)
  end

  def create
    @target_user = User.find(params[:user_id])

    @channel = Channel.find_or_create_dm(current_user, @target_user)

    redirect_to channel_path(@channel)
  end
end
