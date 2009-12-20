require 'activemessaging/processor'
class ThreadEntryObserver < ActiveRecord::Observer
  #include ActiveMessaging::MessageSender
  observe ThreadEntry
  
  #publishes_to :notify_queue
  
  def after_save(threadEntry)
    #TODO: raise exception if smthg goes wrong
    newpayload = Payload.new({:id => threadEntry.id, :type => "threadEntry"})
    payload = YAML.dump(newpayload)
    #TODO: uncomment this line to get error, why can not instantiate Payload Class?!
    #payload = Payload.new(:id => threadEntry.id, :type => "threadEntry")
    #publish :notify_queue, "test3"
    #publish notify_queue, payload
  end
end
