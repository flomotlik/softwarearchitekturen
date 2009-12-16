class CreatePrivateThreads < ActiveRecord::Migration
  def self.up
    create_table :private_threads do |t|
      t.timestamp :date
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :private_threads
  end
end
