class ShowUserContactInfo < ActiveRecord::Migration
  def self.up
    add_column :users, :show_contact_info, :boolean, default: true
  end

  def self.down
    remove_column :users, :show_contact_info
  end
end
