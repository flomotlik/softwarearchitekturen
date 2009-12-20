require 'activemessaging/processor'
#require_dependency '/app/mq/payload'
class ThreadEntryObserver < ActiveRecord::Observer
  #include ActiveMessaging::MessageSender
  observe ThreadEntry
  
  #publishes_to :notify_queue
  
  def after_save(threadEntry)
    #TODO: raise exception if smthg goes wrong
    #YAML
    payload = YAML.dump(Payload.new(:id => threadEntry.id, :kind => "threadEntry"))
    
    #Marshal
    #payload = Marshal.dump(Payload.new(:id => threadEntry.id, :kind => "threadEntry"))
    #payload = Payload.new(:id => threadEntry.id, :type => "threadEntry")
    #publish :notify_queue, "test3"
    #publish :notify_queue, payload
  end
end
