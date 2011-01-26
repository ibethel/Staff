class Department < ActiveRecord::Base
  
  has_many :users
  belongs_to :organization
  has_friendly_id :name, :use_slug => true
  
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :organization_id
  
  scope :within_organization, lambda { |organization|
    where(organization_id: organization.id)
  }
  
end
