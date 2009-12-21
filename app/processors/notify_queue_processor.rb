class NotifyQueueProcessor < ApplicationProcessor

  subscribes_to :notify_queue

  def on_message(message)
    #TODO: YAML unmarhshalling doesnt work
    #payload = YAML.load(message)
    #Marshal
    #payload = Marshal.load(message)
    #puts "received: " + payload.kind
    puts "received: " + message
    
    #TODO: Deserialized object can not be accessed?! Uncomment next line to see.
    #puts "rec" + payload.kind + "rec"
  end
end