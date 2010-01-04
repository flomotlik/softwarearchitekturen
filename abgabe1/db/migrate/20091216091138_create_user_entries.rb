class CreateUserEntries < ActiveRecord::Migration
  def self.up
    create_table :user_entries do |t|
      t.integer :entry_id
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :user_entries
  end
end
