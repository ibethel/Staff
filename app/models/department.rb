class Department < ActiveRecord::Base
  
  has_many :users
  has_friendly_id :name, :use_slug => true
  
end
