require 'activemessaging/processor'
class CommentObserver < ActiveRecord::Observer
  include ActiveMessaging::MessageSender
  observe Comment
  
  publishes_to :notify_queue
  
  def after_save(comment)
    payload = YAML.dump(Paload.new(:id => comment.id, :type => "comment"))
    publish :notify_queue, payload
  end
end
