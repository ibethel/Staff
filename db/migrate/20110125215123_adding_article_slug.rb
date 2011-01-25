class AddingArticleSlug < ActiveRecord::Migration
  def self.up
    add_column :articles, :cached_slug, :string
  end

  def self.down
    remove_column :articles, :cached_slug
  end
end
