class User < ActiveRecord::Base
  
  has_friendly_id :name, :use_slug => true
  has_attached_file :image, default_url: "/images/defaultProfilePic.png", styles: { medium: "150x150!", thumb: "100x100!" }
  has_attached_file :video
  validates :department, presence: true
  validates :position, presence: true
  
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']
  before_save :randomize_file_name
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["user_info"]["name"]
      user.department = "Bethel Church"
      user.position = "Hard Worker"
    end
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