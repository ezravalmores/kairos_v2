class Leave < ActiveRecord::Base
  include PublicActivity::Common
  belongs_to :person
  belongs_to :leave_type
  
  #boolean methods
  #def is_submitted?
  #  self.is_submitted == true  && self.is_approve == false && self.is_disapprove == false
  #end
  
  def is_approved?
    self.is_submitted == true && self.is_approve == true && self.is_disapprove == false
  end
  
  def is_disapproved?
   self.is_submitted == true && self.is_disapprove == true && self.is_approve == false
  end
  
  def is_pending?
   (self.is_submitted == true || self.is_submitted == false) && self.is_disapprove == false && self.is_approve == false
  end
  
  #class methods
  def self.approve_leaves(ids,current_user)
    leaves = where(:id => ids)    
    for leave in leaves
      leave.approve_leave(leave,current_user)  
    end  
  end  
  
  def approve_leave(leave,current_user)
    #if !leave.task_id.nil? && !leave.specific_task_id.nil?
      leave.is_approve = true
      leave.is_disapprove = false
      leave.approve_by = current_user.id
      leave.save!  
    #end
  end 
  
  def self.disapprove_leaves(ids,current_user)
    leaves = where(:id => ids)    
    for leave in leaves
      leave.disapprove_leave(leave,current_user)  
    end  
  end  
  
  def disapprove_leave(leave,current_user)
    #if !leave.task_id.nil? && !leave.specific_task_id.nil?
      leave.is_approve = false
      leave.is_disapprove = true
      leave.approve_by = current_user.id
      leave.save!  
    #end
  end
  
  
  
  def self.find_leaves_to_be_approved(person,*associations,user)
    associations = []
    where = Where.new
    
    #if user.is_admin?
      #if !person.blank?
        
      #  where.and('organizations.name LIKE ?', "%#{user.organization.name}%") 
      #  where.and('leaves.person_id = ?',person) 
      #else
        where.and('leaves.is_submitted =? AND leaves.is_approve =?', true, false)
      #end
    #else
      #if !person.blank?  
      #  where.and('departments.name LIKE ?', "%#{user.department.name}%") 
      #  where.and('organizations.name LIKE ?', "%#{user.organization.name}%")
      #  where.and('leaves.person_id = ?',person) 
      #else
        #where.and('departments.name LIKE ?', "%#{user.department.name}%") 
     #   where.and('organizations.name LIKE ?', "%#{user.organization.name}%")     
      #end   
      
      associations << [{:person => [:department, :organization] }]
      leaves = Leave.scoped({})

      leaves = leaves.all(:include => associations.uniq,:conditions => where.to_s, :order =>'leaves.date DESC, leaves.person_id')  
  end
  
  
  #intance method
  def approved?(approved_by = self.approve_by)
    if !approved_by.nil?
      name = approved_by_who(approved_by)
    else
      name = "none"  
    end  
  end  
  
  def approved_by_who(approved_by)
    approved_by_who = Person.find(approved_by).name
  end  
  
  def is_submitted?
    self.is_submitted == true
  end  
  
  #def is_approved?
  #  is_approve == true
  #end  
  
  def is_canceled?
    is_canceled == true
  end  
  
end
