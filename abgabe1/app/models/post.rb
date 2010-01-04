class Post < ActiveRecord::Base
  has_many :post_comment
  has_many :user_post
end
