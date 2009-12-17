class CreateThreadEntries < ActiveRecord::Migration
  def self.up
    create_table :thread_entries do |t|
      t.references :entry
      t.references :thread

      t.timestamps
    end
  end

  def self.down
    drop_table :thread_entries
  end
end
