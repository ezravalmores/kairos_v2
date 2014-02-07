class Organization < ActiveRecord::Base
  has_many :people
  has_many :departments
end  
