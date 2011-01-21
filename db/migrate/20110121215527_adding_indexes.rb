class AddingIndexes < ActiveRecord::Migration
  def self.up
    add_index :users, :updated_at
    add_index :friendships, :user_id
  end

  def self.down
    remove_index :users, :updated_at
    remove_index :friendships, :user_id
  end
end
