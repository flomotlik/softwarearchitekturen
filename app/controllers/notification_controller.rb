class NotificationController < ApplicationController
  def show
    @notifications = DaoHelper.instance.find_notifications_by_userid(current_user.id)
    render :partial => "notification/show"
  end
end
