class SpecificTask < ActiveRecord::Base
  #belongs_to :department
  belongs_to :task
  has_many :person_tasks
  belongs_to :department
  
  validates_presence_of :name, :activity
  
  scope :active, where(:is_active => true)
  
  #instance method
  def deactivate
    update_attributes(:is_active => false)    
  end
  
  def activate
    update_attributes(:is_active => true)
  end
  
  #class methods
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