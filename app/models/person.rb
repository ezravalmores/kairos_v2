class Person < ActiveRecord::Base
  include PublicActivity::Model
  
  has_many :person_tasks
  has_many :utilization_rates
  has_many :leaves, :class_name => "Leave"
  belongs_to :role
  belongs_to :organization_role
  belongs_to :department
  belongs_to :organization
  
  validates_presence_of :first_name, :last_name #, :email_address, :time_zone, :organization_id, :department_id, :organization_role, :role, :username, :password
  
  #validates_uniqueness_of :email_address
  
  # Named scopes
  scope :active, where(:is_active => true)
  scope :can_approve, where(:can_approve => true)
  
  # Class methods
  def self.authenticate(username,password)
    find_by_username_and_password(username.downcase,password)
  end  
  
  def self.fetch_employees(organization,role,department)
    if role.name == 'Administrator'
      people = where('organization_id =?', organization.id).order('first_name ASC')
    else  
      people = where('organization_id =? AND department_id =?', organization.id,department.id).order('first_name ASC')
      people += where('organization_id =? AND department_id IS NULL', organization.id).order('first_name ASC')   
    end  
  end
  
  def short_name
    "#{self.first_name} #{self.last_name[0,1].upcase}"
  end
  
  # Boolean methods
  def has_right?(action,context)
    role.has_right?(action,context)
  end

  def is_admin?
    (!role.nil? && role.name == 'Administrator')
  end
  alias :admin? :is_admin?
  
  #instance method
  def name
    first_name + " " + last_name  
  end  
  
end  