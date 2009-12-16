class UserThread < ActiveRecord::Base
  has_one :private_thread
  has_one :user
end
