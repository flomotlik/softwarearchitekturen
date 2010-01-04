class CreatePrivateThreads < ActiveRecord::Migration
  def self.up
    create_table :private_threads do |t|
      t.timestamp :date
      t.string :title
      t.integer :author_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :private_threads
  end
end
