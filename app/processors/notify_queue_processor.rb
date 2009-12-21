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
      notifyThreadEntry(params[0])
    end
    
    #TODO: Deserialized object can not be accessed?! Uncomment next line to see.
    #puts "rec" + payload.kind + "rec"
  end
  
  def notifyThreadEntry(param)
    puts param.to_i
    users = DaoHelper.find_users_by_threadid(param.to_i)
    puts "hi"
    puts users.length
    for user in users
      puts user.login
    end
    #puts param
  end
  
  def notifyComment(param)
   puts param
  end
end