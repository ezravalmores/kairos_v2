class SpecificTask < ActiveRecord::Base
  #belongs_to :department
  belongs_to :task
  has_many :person_tasks
  has_many :role_specific_tasks
  belongs_to :department
  belongs_to :organization
  
  validates_presence_of :name, :description, :organization_id
  scope :active, where(:is_active => true)
  
  #instance method
  def deactivate
    update_attributes(:is_active => false)    
  end
  
  def activate
    update_attributes(:is_active => true)
  end
  
  #class methods
  def self.fetch_specific_tasks(organization,role,department)
     if role.name == 'Administrator'
       specific_tasks = where('organization_id =?', organization.id)
     else  
       specific_tasks = where('organization_id =? AND department_id =?', organization.id,department.id)
       specific_tasks += where('organization_id =? AND department_id IS NULL', organization.id)
     end  
   end
  
  def self.deactivate_specific_activities(specific_activities)
    specific_activities.each do |sa|
      sa.deactivate  
    end        
  end  
  
  def self.activate_specific_activities(specific_activities)
    specific_activities.each do |sa|
      sa.activate  
    end        
  end
end  