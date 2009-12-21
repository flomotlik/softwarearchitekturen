require 'activemessaging/processor'

class ThreadEntryObserver < ActiveRecord::Observer
  include ActiveMessaging::MessageSender
  observe ThreadEntry
  
  publishes_to :notify_queue
  
  def after_save(threadEntry)
    #TODO: raise exception if smthg goes wrong
    #YAML
    #payload = YAML.dump(Payload.new(:id => threadEntry.id, :kind => "thread_entry"))
    #un = YAML.load(payload)
    #puts un.kind

    payload = threadEntry.thread_id.to_s + "!thread_entry"
    #Marshal
    #payload = Marshal.dump(Payload.new(:id => threadEntry.id, :kind => "threadEntry"))
    #payload = Payload.new(:id => threadEntry.id, :type => "threadEntry")
    #publish :notify_queue, "test3"
    publish :notify_queue, payload
  end
end
