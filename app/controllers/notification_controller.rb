class NotificationController < ApplicationController
  def show
    @notifications = Notification.find_all_by_user_id(1)
    render :partial => "notification/show"
  end
end
