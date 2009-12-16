class CreateThreads < ActiveRecord::Migration
  def self.up
    create_table :threads do |t|
      t.timestamp :date
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :threads
  end
end
