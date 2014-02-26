class Role < ActiveRecord::Base
  has_many :people
  has_many :role_task
  
  has_many :rights, :dependent => :delete_all
  
  
  # Boolean methods
  def has_right?(action,context)
    !self.rights.detect{ |right| right.has?(action,context) }.nil?
  end
end  
