class User < ActiveRecord::Base
  
  has_friendly_id :name, :use_slug => true
  has_attached_file :image
  has_attached_file :video
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["user_info"]["name"]
    end
  end
  
  def image
    "defaultProfilePic.png" if read_attribute(:image).nil? 
  end
  
end