class RoleSpecificTask < ActiveRecord::Base
  belongs_to :organization
  belongs_to :department
  belongs_to :specific_task
  belongs_to :organization_role
  
  belongs_to :role_task
end