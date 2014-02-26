class Person < ActiveRecord::Base
  has_many :person_tasks
  has_many :utilization_rates
  belongs_to :role
  belongs_to :organization_role
  belongs_to :department
  belongs_to :organization
  
  validates_presence_of :first_name, :last_name, :email_address, :time_zone, :organization_id, :department_id, :organization_role, :role, :username, :password
  
  #validates_uniqueness_of :email_address
  
  # Named scopes
  scope :active, where(:is_active => true)
  scope :can_approve, where(:can_approve => true)
  
  # Class methods
  def self.authenticate(username,password)
    find_by_username_and_password(username.downcase,password)
  end  
  
  # Boolean methods
  def has_right?(action,context)
    role.has_right?(action,context)
  end

  def is_admin?
    (!role.nil? && role.name == 'Administrator')
  end
  alias :admin? :is_admin?
end  