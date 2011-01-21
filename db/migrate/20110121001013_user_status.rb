class UserStatus < ActiveRecord::Migration
  def self.up
    add_column :users, :deleted, :boolean, default: false
    add_column :users, :admin, :boolean, default: false
  end

  def self.down
    remove_column :users, :deleted
    remove_column :users, :admin
  end
end
