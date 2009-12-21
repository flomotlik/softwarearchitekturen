class CreateUserComments < ActiveRecord::Migration
  def self.up
    create_table :user_comments do |t|
      t.integer :comment_id
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :user_comments
  end
end
