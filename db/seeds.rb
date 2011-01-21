# User.build_user_list

["Web", "Accounting", "Jesus Culture", "Graphics", "Manufacturing", "Video", "Global Legacy", "IBSSM", "Human Resources", "Information Technology", "Customer Support", "Transformation Center", "BCS", "School of Worship", "Missions", "Music", "Marketing", "Eagles Nest", "Moral Revolution", "Media", "Office Staff", "Maintenance", "Pastor on Call", "Youth", "Iris Ministries"].sort.each do |name|
  Department.create(name: name)
end
