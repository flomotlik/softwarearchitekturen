require File.dirname(__FILE__) + '/../test_helper'
require 'activemessaging/test_helper'
require File.dirname(__FILE__) + '/../../app/processors/application'

class NotifyQueueProcessorTest < Test::Unit::TestCase
  include ActiveMessaging::TestHelper
  
  def setup
    load File.dirname(__FILE__) + "/../../app/processors/notify_queue_processor.rb"
    @processor = NotifyQueueProcessor.new
  end
  
  def teardown
    @processor = nil
  end  

  def test_notify_queue_processor
    @processor.on_message('Your test message here!')
  end
end