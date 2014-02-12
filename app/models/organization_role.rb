class OrganizationRole < ActiveRecord::Base
  belongs_to :organization  
  has_many :people
  has_many :role_specific_tasks
  has_many :role_tasks
  
  #class methods
  
  def self.organization_roles(organization)
    where('organization_id =?', organization.id)      
  end
end  