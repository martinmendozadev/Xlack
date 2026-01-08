class MessagesController < ApplicationController
  def create
    @channel = Channel.find(params[:channel_id])
    @message = @channel.messages.build(message_params)
    @message.user = current_user

    if @message.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("messages", partial: "messages/message", locals: { message: @message }),

            turbo_stream.replace("new_message_form", partial: "messages/form", locals: { channel: @channel })
          ]
        end
        format.html { redirect_to channel_path(@channel) }
      end
    else
      render turbo_stream: turbo_stream.replace("new_message_form", partial: "messages/form", locals: { channel: @channel })
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :parent_id)
  end
end
