class AddingDepartmentUrl < ActiveRecord::Migration
  def self.up
    add_column :departments, :cached_slug, :string
    
    # This will generate the URL
    Department.all.each { |department| department.save }
  end

  def self.down
    remove_column :departments, :cached_slug
  end
end
