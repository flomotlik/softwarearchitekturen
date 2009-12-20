class NotifyQueueProcessor < ApplicationProcessor

  subscribes_to :notify_queue

  def on_message(message)
    #payload = YAML.load(message)
    puts "received: " + message
  end
end