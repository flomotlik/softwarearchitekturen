class CreateUserNotifications < ActiveRecord::Migration
  def self.up
    create_table :user_notifications do |t|
      t.decimal :notification_id
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :user_notifications
  end
end
