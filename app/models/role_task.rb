class RoleTask < ActiveRecord::Base
  belongs_to :organization
  belongs_to :department
  
  belongs_to :task
  belongs_to :organization_role
  
  has_many :role_specific_tasks, :class_name => 'RoleSpecificTask', :conditions => { :is_active => true }
end  