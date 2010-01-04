class PrivateThread < ActiveRecord::Base
  has_many :thread_entries
  has_many :user_threads
  attr_accessor :date_of_newest_entry
end
