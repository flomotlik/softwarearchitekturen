class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
      t.timestamp :date
      t.decimal :friend_id
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :friendships
  end
end
