class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.text :content
      t.timestamp :date
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
