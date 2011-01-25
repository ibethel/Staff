class IndexForOrganization < ActiveRecord::Migration
  def self.up
    add_index :users, :organization_id
    add_index :departments, :organization_id
  end

  def self.down
    remove_index :users, :organization_id
    remove_index :departments, :organization_id
  end
end
