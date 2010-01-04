class CreateUserThreads < ActiveRecord::Migration
  def self.up
    create_table :user_threads do |t|
      t.references :private_thread
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :user_threads
  end
end
