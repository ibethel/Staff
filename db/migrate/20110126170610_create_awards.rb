class CreateAwards < ActiveRecord::Migration
  def self.up
    create_table :awards do |t|
      t.references :organization
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :awards
  end
end
