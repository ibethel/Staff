class AddingAttachments < ActiveRecord::Migration
  def self.up
        add_column :users, :image_file_name,    :string
        add_column :users, :image_content_type, :string
        add_column :users, :image_file_size,    :integer
        add_column :users, :image_updated_at,   :datetime
        
        add_column :users, :video_file_name,    :string
        add_column :users, :video_content_type, :string
        add_column :users, :video_file_size,    :integer
        add_column :users, :video_updated_at,   :datetime
      end

      def self.down
        remove_column :users, :image_file_name
        remove_column :users, :image_content_type
        remove_column :users, :image_file_size
        remove_column :users, :image_updated_at
        
        remove_column :users, :video_file_name
        remove_column :users, :video_content_type
        remove_column :users, :video_file_size
        remove_column :users, :video_updated_at
      end
end
