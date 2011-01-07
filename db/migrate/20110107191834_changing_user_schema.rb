class ChangingUserSchema < ActiveRecord::Migration
  def self.up
    remove_column :users, :uid
    remove_column :users, :provider
    add_column :users, :email, :string
  end

  def self.down
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    remove_column :users, :email
  end
end
