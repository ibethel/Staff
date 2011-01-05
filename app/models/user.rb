class User < ActiveRecord::Base
  
  has_friendly_id :name, :use_slug => true
  has_attached_file :image, default_url: "/images/defaultProfilePic.png", styles: { medium: "150x150!", thumb: "100x100!" }
  has_attached_file :video
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["user_info"]["name"]
    end
  end
  
end