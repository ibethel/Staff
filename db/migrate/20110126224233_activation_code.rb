class ActivationCode < ActiveRecord::Migration
  def self.up
    add_column :users, :activation, :string
  end

  def self.down
    remove_column :users, :activation
  end
end
