class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: "User"
  
  validates_uniqueness_of :user_id, :scope => :friend_id
  validates_associated :user, :friend
end
