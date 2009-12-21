class NotifyQueueProcessor < ApplicationProcessor

  subscribes_to :notify_queue

  def on_message(message)
    #TODO: YAML unmarhshalling doesnt work
    #payload = YAML.load(message)
    #Marshal
    #payload = Marshal.load(message)
    #puts message
    #puts "received: " + payload.kind
    params = message.split('!')
    if params[1] == "comment"
      notifyComment(params[0])
    else
      notifyThreadEntry(params[0], params[2])
    end
    
    #TODO: Deserialized object can not be accessed?! Uncomment next line to see.
    #puts "rec" + payload.kind + "rec"
  end
  
  def notifyThreadEntry(threadId, entryId)
    users = DaoHelper.instance.find_users_by_threadid(threadId.to_i)
    entry = DaoHelper.instance.find_entry(entryId.to_i)
    
    for user in users
      if user.id != entry.user_id
        n = Notification.new(:reason => "thread_entry", :user_id => user.id, :date => Time.new , :object_id => threadId.to_i)
        DaoHelper.instance.save_notification(n)
        un = UserNotification.new(:user_id => user.id, :notification_id => n.id)
        DaoHelper.instance.save_user_notification(un)
      end
    end
  
  end
  
  def notifyComment(param)
   puts param
  end
end