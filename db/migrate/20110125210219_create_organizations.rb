class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name

      t.timestamps
    end
    
    add_column :users, :organization_id, :integer
    add_column :departments, :organization_id, :integer
  end

  def self.down
    drop_table :organizations
    remove_column :users, :organization_id
    remove_column :departments, :organization_id
  end
end
