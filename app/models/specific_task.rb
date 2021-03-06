class SpecificTask < ActiveRecord::Base
  #belongs_to :department
  belongs_to :task
  has_many :person_tasks
  has_many :role_specific_tasks
  belongs_to :department
  belongs_to :organization
  
  validates_presence_of :name, :description, :organization_id
  validates_uniqueness_of :name, :on => :create
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
       specific_tasks = where('organization_id =?', organization.id).order('name ASC')
     else  
       specific_tasks = where('organization_id =? AND department_id =?', organization.id,department.id).order('name ASC')
       specific_tasks += where('organization_id =? AND department_id IS NULL', organization.id).order('name ASC')
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