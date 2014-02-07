class Task < ActiveRecord::Base
  has_many :person_tasks
  has_many :specific_tasks
  #belongs_to :department
  
  validates_presence_of :name
  
  scope :active, where(:is_active => true)
  scope :view_all, where(:can_view_to_all_org => true)
end
