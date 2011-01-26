class Article < ActiveRecord::Base
  
  belongs_to :user
  validates_presence_of :title, :content
  has_friendly_id :title, :use_slug => true
  
  default_scope order: "updated_at DESC"
  scope :belongs_to_user, lambda { |user|
    where(:user, user)
  }

end