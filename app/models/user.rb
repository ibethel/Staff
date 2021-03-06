require 'gappsprovisioning/provisioningapi'

class User < ActiveRecord::Base
  
  include GAppsProvisioning
  
  has_many :articles
  has_many :friendships
  has_many :friends, through: :friendships
  belongs_to :department
  belongs_to :organization
  
  has_friendly_id :name, :use_slug => true
  has_attached_file :image, default_url: "/images/defaultProfilePic.png", styles: { medium: "150x113!", thumb: "100x100!" }
  has_attached_file :video
  
  
  validates :department, presence: true
  validates :position, presence: true
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']
  
  scope :active, lambda {
    where(deleted: false)
  }
  
  scope :within_organization, lambda { |organization|
    where(organization_id: organization.id)
  }
  
  before_save :randomize_file_name
  before_create :generate_activation_code
  
  # Build all of the users  
  def self.build_user_list
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
  
  # Show all of the people that the user is not friends with
  def missing_connections
    User.where('id NOT IN(?)', friendships.map(&:friend_id)).active.limit(8)
  end
  
  def is_admin?
    admin
  end
  
  
  private
  
    def generate_activation_code
       self.activation = UUIDTools::UUID.timestamp_create().to_s
    end

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