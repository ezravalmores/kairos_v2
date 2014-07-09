class Event < ActiveRecord::Base
  include PublicActivity::Common
  
  belongs_to :creator, :class_name => "Person", :foreign_key => "created_by"
  
  
  validates_presence_of :description, :from, :to
  
end  