class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.string :reason
      t.decimal :user_id
      t.timestamp :date
      t.decimal :object_id

      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
