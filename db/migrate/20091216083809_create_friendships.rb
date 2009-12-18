class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
      t.timestamp :date
      t.integer :friend
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :friendships
  end
end
