class Organization < ActiveRecord::Base
  
  has_many :users
  has_many :departments
  has_many :awards
  
  has_friendly_id :name, :use_slug => true
  validates_uniqueness_of :name
  
end