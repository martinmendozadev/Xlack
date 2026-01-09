class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.recent.includes(:actor, :message)

    current_user.notifications.unread.update_all(read_at: Time.current)
  end
end
