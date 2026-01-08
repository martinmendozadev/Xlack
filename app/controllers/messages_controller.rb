class MessagesController < ApplicationController
  def create
    @channel = Channel.find(params[:channel_id])
    @message = @channel.messages.build(message_params)
    @message.user = current_user

    if @message.save
      respond_to do |format|
        format.turbo_stream do
          if @message.parent_id
            render turbo_stream: turbo_stream.replace("thread_reply_form",
                                                      partial: "messages/form_thread",
                                                      locals: { channel: @channel, parent: @message.parent })
          else
            render turbo_stream: turbo_stream.replace("new_message_form",
                                                      partial: "messages/form",
                                                      locals: { channel: @channel })
          end
        end
        format.html { redirect_to channel_path(@channel) }
      end
    else
      redirect_to channel_path(@channel), alert: t("messages.create_failure")
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
