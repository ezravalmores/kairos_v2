class Department < ActiveRecord::Base
  has_many :people
  belongs_to :organization
  
  def self.departments(organization,system_role,department)
    if system_role.name == 'Administrator'
      where('organization_id =?',organization.id)     
    elsif system_role.name == '1st Level User'
      where('id =? AND organization_id =?', department.id,organization.id)
    end      
  end
end  
