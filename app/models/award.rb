class Award < ActiveRecord::Base
  belongs_to :organization
  validates_uniqueness_of :name, scope: :organization_id
end
