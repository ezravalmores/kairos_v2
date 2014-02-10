class Role < ActiveRecord::Base
  has_many :people
  has_many :role_task
end  
