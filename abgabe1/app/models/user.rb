class User < ActiveRecord::Base
  acts_as_authentic do |c|
  end
  
  has_many :friendships
  has_many :user_posts
  has_many :user_notifications
  has_many :user_blocks
  has_many :user_entries
  has_many :user_comment
end
