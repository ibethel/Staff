class UserInfo < ActiveRecord::Migration
  def self.up
    add_column :users, :department, :string
    add_column :users, :position, :string
    add_column :users, :bio, :text
  end

  def self.down
    remove_column :users, :department
    remove_column :users, :position
    remove_column :users, :bio
  end
end