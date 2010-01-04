require 'activemessaging/processor'

class CommentObserver < ActiveRecord::Observer
  include ActiveMessaging::MessageSender
  observe Comment
  
  publishes_to :notify_queue
  
  def after_save(comment)

    #payload = threadEntry.id.to_s + "!comment" 
    #Marshal
    #payload = Marshal.dump(Payload.new(:id => threadEntry.id, :kind => "threadEntry"))
    #payload = Payload.new(:id => threadEntry.id, :type => "threadEntry")
    #publish :notify_queue, "test3"
    #publish :notify_queue, payload

  end
end
