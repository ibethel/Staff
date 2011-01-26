class AwardsIndex < ActiveRecord::Migration
  def self.up
    add_index :awards, :organization_id
    add_index :departments, :cached_slug
    add_index :users, :cached_slug
    add_index :organizations, :cached_slug
    add_index :articles, :cached_slug
  end

  def self.down
    remove_index :awards, :organization_id
    remove_index :departments, :cached_slug
    remove_index :users, :cached_slug
    remove_index :organizations, :cached_slug
    remove_index :articles, :cached_slug
  end
end
