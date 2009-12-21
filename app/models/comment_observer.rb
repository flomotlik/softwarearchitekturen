require 'activemessaging/processor'

class CommentObserver < ActiveRecord::Observer
  include ActiveMessaging::MessageSender
  observe Comment
  
  publishes_to :notify_queue
  
  def after_save(comment)
    payload = comment.id.to_s + "!comment" 
    #publish :notify_queue, "test3!comment"
    publish :notify_queue, payload
  end
end
