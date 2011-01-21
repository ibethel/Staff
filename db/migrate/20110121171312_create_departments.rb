class CreateDepartments < ActiveRecord::Migration
  def self.up
    
    remove_column :users, :department
    add_column :users, :department_id, :integer
    
    create_table :departments do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :departments
  end
end
