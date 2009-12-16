class CreateUserBlocks < ActiveRecord::Migration
  def self.up
    create_table :user_blocks do |t|
      t.decimal :blocked_id
      t.references :user
      t.timestamp :date

      t.timestamps
    end
  end

  def self.down
    drop_table :user_blocks
  end
end
