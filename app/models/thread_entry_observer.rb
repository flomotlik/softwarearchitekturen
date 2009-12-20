require 'activemessaging/processor'
class ThreadEntryObserver < ActiveRecord::Observer
  include ActiveMessaging::MessageSender
  observe ThreadEntry
  
  publishes_to :notify_queue
  
  def after_save(threadEntry)
    #TODO: raise exception if smthg goes wrong

    #payload = YAML.dump(Payload.new(:id => threadEntry.id, :type => "threadEntry"))
    #TODO: uncomment this line to get error, why can not instantiate Payload Class?!
    #payload = Payload.new(:id => threadEntry.id, :type => "threadEntry")
    publish :notify_queue, "test3"
    #publish notify_queue, payload
  end
end
