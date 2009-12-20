class NotifyQueueProcessor < ApplicationProcessor

  subscribes_to :notify_queue

  def on_message(message)
    #TODO: YAML unmarhshalling doesnt work
    payload = YAML.load(message)
    #Marshal
    #payload = Marshal.load(message)
    #puts "received: " + payload.kind
    puts "received: " + message
    puts payload.id
  end
end