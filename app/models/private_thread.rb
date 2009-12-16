class PrivateThread < ActiveRecord::Base
  has_many :thread_entries
  has_many :user_threads
end
