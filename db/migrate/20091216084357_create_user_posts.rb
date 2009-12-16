class CreateUserPosts < ActiveRecord::Migration
  def self.up
    create_table :user_posts do |t|
      t.decimal :post_id
      t.references :user
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :user_posts
  end
end
