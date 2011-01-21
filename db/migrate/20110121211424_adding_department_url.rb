class AddingDepartmentUrl < ActiveRecord::Migration
  def self.up
    add_column :departments, :cached_slug, :string
  end

  def self.down
    remove_column :departments, :cached_slug
  end
end
