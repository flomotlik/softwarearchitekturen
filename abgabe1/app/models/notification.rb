class Notification < ActiveRecord::Base
  @@types = {
  :comment => "comment",
  :thread_entry => "thread_entry"  
  }
  
  validates_inclusion_of :reason, :in => ["comment", "thread_entry"]
end
