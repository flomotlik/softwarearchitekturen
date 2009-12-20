require 'activemessaging/processor'
class CommentObserver < ActiveRecord::Observer
  include ActiveMessaging::MessageSender
  observe Comment
  
  publishes_to :notify_queue
  
  def after_save(comment)
    #TODO: raise exception if smthg goes wrong
    
    #payload = YAML.dump(Payload.new(:id => comment.id, :type => "comment"))
    #publish :notify_queue, payload
  end
end
