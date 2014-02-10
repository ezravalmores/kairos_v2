class Person < ActiveRecord::Base
  has_many :person_tasks
  belongs_to :role
  belongs_to :organization_role
  belongs_to :department
  belongs_to :organization
  
  
  # Named scopes
  scope :active, where(:is_active => true)
  scope :can_approve, where(:can_approve => true)
  
  # Class methods
  def self.authenticate(username,password)
    find_by_username_and_password(username.downcase,password)
  end  
end  