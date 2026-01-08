class MessagesController < ApplicationController
  def create
    @channel = Channel.find(params[:channel_id])
    @message = @channel.messages.build(message_params)
    @message.user = current_user

    if @message.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("new_message_form", partial: "messages/form", locals: { channel: @channel })
          ]
        end
        format.html { redirect_to channel_path(@channel) }
      end
    else
      render turbo_stream: turbo_stream.replace("new_message_form", partial: "messages/form", locals: { channel: @channel })
    end
  end

  def show
    @channel = Channel.find(params[:channel_id])
    @parent_message = Message.find(params[:id])

    @replies = @parent_message.replies.includes(:user).order(created_at: :asc)

    @new_reply = Message.new(parent_id: @parent_message.id)
  end

  private

  def message_params
    params.require(:message).permit(:content, :parent_id)
  end
end
