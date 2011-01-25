class SlugForOrganization < ActiveRecord::Migration
  def self.up
    add_column :organizations, :cached_slug, :string
  end

  def self.down
    remove_column :organizations, :cached_slug
  end
end
