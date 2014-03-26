class Task < ActiveRecord::Base
  include PublicActivity::Common
  
  has_many :person_tasks
  has_many :specific_tasks
  has_many :role_tasks
  belongs_to :organization
  belongs_to :department
  
  validates_presence_of :name, :organization_id, :description
  validates_uniqueness_of :name, :on => :create
  
  scope :active, where(:is_active => true)
  scope :view_all, where(:can_view_to_all_org => true)
  
  def self.fetch_tasks(organization,role,department)
    if role.name == 'Administrator'
      tasks = where('organization_id =?', organization.id).order('name ASC')
    else  
      tasks = where('organization_id =? AND department_id =?', organization.id,department.id).order('name ASC')
      tasks += where('organization_id =? AND department_id IS NULL', organization.id).order('name ASC')   
    end  
  end
  
end
