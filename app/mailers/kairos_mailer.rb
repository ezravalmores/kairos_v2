class KairosMailer < ActionMailer::Base
  default from: "ncmmanila@example.com"
  
  def send_approvals(person,submitted_by,shift_date)
    @submitted_by = submitted_by
    @to = person
    @shift_date = shift_date
     #for person in people 
        @person = person
        mail(:to => person.email_address, :from => "Kairos <no-reply@ncm.org>", :subject => "Tasks Approvals")
    #end    
  end 
  
  def submit_leaves(person,submitted_by,leaves)
    @submitted_by = submitted_by
    @leaves = leaves
    
    mail(:to => person.email_address, :from => "Kairos <no-reply@ncm.org>", :subject => "Leave(s) Approvals") 
  end
  
  def create_event(person,created_by,events,people)
    @created_by = created_by
    @events = events
    @people = people
    
    mail(:to => person.email_address, :from => "Kairos <no-reply@ncm.org>", :subject => "New Event") 
  end
  
  def remove_person(person,removed_by,event)
    @removed_by = removed_by
    @event = event
    
    mail(:to => person.email_address, :from => "Kairos <no-reply@ncm.org>", :subject => "New Event") 
  end
  
  def cancel_leave(person,submitted_by,leave)
    @submitted_by = submitted_by
    @leave = leave
    
    mail(:to => person.email_address, :from => "Kairos <no-reply@ncm.org>", :subject => "Leave(s) Approvals") 
  end
  
  def approve_leave(person,submitted_by,leave)
    @approved_by = submitted_by
    @leave = leave
    
    mail(:to => person.email_address, :from => "Kairos <no-reply@ncm.org>", :subject => "Leave(s) Approvals") 
  end
  
  def disapprove_leave(person,submitted_by,leave)
    @disapproved_by = submitted_by
    @leave = leave
    
    mail(:to => person.email_address, :from => "Kairos <no-reply@ncm.org>", :subject => "Leave(s) dispprovals") 
  end
end  