class Award < ActiveRecord::Base
  belongs_to :organization
  validates_uniqueness_of :name, scope: :organization_id
  validates_presence_of :name
end
