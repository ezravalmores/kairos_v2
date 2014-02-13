class Organization < ActiveRecord::Base
  has_many :people
  has_many :departments
  has_many :organization_roles
  has_many :tasks
  has_many :specific_tasks
end  
