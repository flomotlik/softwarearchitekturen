require 'activemessaging/processor'
class ThreadEntryObserver < ActiveRecord::Observer
  include ActiveMessaging::MessageSender
  observe ThreadEntry
  
  publishes_to :notify_queue
  
  def after_create(threadEntry)
    payload = YAML.dump(Payload.new(:id => threadEntry.id, :type => "threadEntry"))
  end
end
