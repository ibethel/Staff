require 'gappsprovisioning/provisioningapi'

class User < ActiveRecord::Base
  
  include GAppsProvisioning
  
  default_scope limit: 50, order: "updated_at DESC"
  
  has_many :friendships
  has_many :friends, through: :friendships
  
  has_friendly_id :name, :use_slug => true
  has_attached_file :image, default_url: "/images/defaultProfilePic.png", styles: { medium: "150x113!", thumb: "100x100!" }
  has_attached_file :video
  
  
  validates :department, presence: true
  validates :position, presence: true
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']
  
  
  before_save :randomize_file_name
  
  # Build all of the users
  
  class << self
    
    def build_user_list
      adminuser = "chrisg@ibethel.org"
      password  = "Bulld0g"
      myapps = ProvisioningApi.new(adminuser, password)

      myapps.retrieve_all_users.each do |user|
        current_user = User.find_by_email("#{user.username}@ibethel.org")
        if current_user
          current_user.update_attributes(name: "#{user.given_name} #{user.family_name}")
          current_user.save
        else
          User.create!(email: "#{user.username}@ibethel.org".downcase, name: "#{user.given_name} #{user.family_name}", department: "Bethel Church", position: "Hard Worker")
        end
      end
    end
    
  end
  
  
  
  # Show all of the people that the user is not friends with
  def missing_connections
    User.where('id NOT IN(?)', friendships.map(&:friend_id)).limit(8)
  end
  
  
  private

    def randomize_file_name
      if image_file_name_changed?
        extension = File.extname(image_file_name).downcase
        self.image.instance_write(:file_name, "#{ActiveSupport::SecureRandom.hex(16)}#{extension}")
      end
      
      if video_file_name_changed?
        extension = File.extname(video_file_name).downcase
        self.video.instance_write(:file_name, "#{ActiveSupport::SecureRandom.hex(16)}#{extension}")
      end
    end
  
end