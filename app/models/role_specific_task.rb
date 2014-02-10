class RoleSpecificTask < ActiveRecord::Base
  belongs_to :organization
  belongs_to :department
  
  belongs_to :role_task
end