class ApprovalsController < ApplicationController
  require 'will_paginate/array'
 
  before_filter :authorize
  
  def tasks_approval
    session[:person] = params[:person]
    @for_approvals = PersonTask.find_tasks_to_be_approved(params[:person],[:task,:specific_task,{:person => [:department, :organization] }],current_user)
    @total_count = @for_approvals.length 
    @for_approvals = @for_approvals.paginate(:page => params[:page],:per_page => 100)
  end
  
  def approve_tasks
    PersonTask.approve_tasks(params[:p_tasks],current_user)
    flash[:notice] = 'Process completed by' + " " + current_user.first_name + " " + current_user.last_name 

    @for_approvals = PersonTask.find_tasks_to_be_approved(session[:person],[:task,:specific_task,{:person => [:department, :organization] }],current_user)
    @total_count = @for_approvals.length 
    @for_approvals = @for_approvals.paginate(:page => params[:page],:per_page => 100)
  end
  
  def disapprove_tasks
    PersonTask.disapprove_tasks(params[:p_tasks],current_user)
    flash[:notice] = 'Proccess completed by' + " " + current_user.first_name + " " + current_user.last_name 

    @for_approvals = PersonTask.find_tasks_to_be_approved(session[:person],[:task,:specific_task,{:person => [:department, :organization] }],current_user)
    @total_count = @for_approvals.length 
    @for_approvals = @for_approvals.paginate(:page => params[:page],:per_page => 100)
  end
  
  def leaves_approval
    @for_approvals = Leave.find_leaves_to_be_approved({:person => [:department, :organization]},current_user)
    @total_count = @for_approvals.length 
    @for_approvals = @for_approvals.paginate(:page => params[:page],:per_page => 100)
  end
  
  def approve_leaves
    @leaves = Leave.where(:id => params[:leaves])
    
    Leave.approve_leaves(@leaves,current_user)
    
    people_ids = @leaves.map {|p| p.person_id}.join(",")  
    @people = Person.where(:id => people_ids.split(','))
    
    for leave in @leaves
      for person in @people
        if leave.person_id == person.id 
          KairosMailer.approve_leave(person,current_user,leave).deliver        
          leave.create_activity :approve_leaves, owner: current_user, recipient: person, date: leave.date
        end  
      end
    end  
    
    @for_approvals = Leave.find_leaves_to_be_approved({:person => [:department, :organization]},current_user)
    @total_count = @for_approvals.length 
    @for_approvals = @for_approvals.paginate(:page => params[:page],:per_page => 100)
    
    flash[:notice] = 'Process completed by' + " " + current_user.first_name + " " + current_user.last_name 
    
  end
  
  def disapprove_leaves
     @leaves = Leave.where(:id => params[:leaves])

      Leave.disapprove_leaves(@leaves,current_user)

      people_ids = @leaves.map {|p| p.person_id}.join(",")  
      @people = Person.where(:id => people_ids.split(','))

      for leave in @leaves
        for person in @people
          if leave.person_id == person.id 
            KairosMailer.disapprove_leave(person,current_user,leave).deliver        
            leave.create_activity :disapprove_leaves, owner: current_user, recipient: person, date: leave.date
          end  
        end
      end

    @for_approvals = Leave.find_leaves_to_be_approved({:person => [:department, :organization]},current_user)
    @total_count = @for_approvals.length 
    @for_approvals = @for_approvals.paginate(:page => params[:page],:per_page => 100)
    
    flash[:notice] = 'Proccess completed by' + " " + current_user.first_name + " " + current_user.last_name 
    
  end
end  