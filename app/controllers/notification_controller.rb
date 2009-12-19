class NotificationController < ApplicationController
  def index
    @notifications = Notification.find(:all)
    n = Notification.create(:reason => "comment", :user_id => 1)
    @saved = n.save
    @errors = n.errors
  end
end
