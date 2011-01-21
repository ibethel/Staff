# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
User.build_user_list

["Web", "Accounting", "Jesus Culture", "Graphics", "Manufacturing", "Video", "Global Legacy", "IBSSM", "Human Resources", "Information Technology", "Customer Support", "Transformation Center", "BCS", "School of Worship", "Missions", "Music", "Marketing", "Eagles Nest", "Moral Revolution", "Media", "Office Staff", "Maintenance", "Pastor on Call", "Youth", "Iris Ministries"].sort.each do |name|
  Department.create(name: name)
end
