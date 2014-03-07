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
    PersonTask.approve_tasks(params[:p_tasks])
    
    @for_approvals = PersonTask.find_tasks_to_be_approved(session[:person],[:task,:specific_task,{:person => [:department, :organization] }],current_user)
    @total_count = @for_approvals.length 
    @for_approvals = @for_approvals.paginate(:page => params[:page],:per_page => 100)
    
    flash[:notice] = 'Activities was successfuly approved by' + " " + current_user.first_name + " " + current_user.last_name
  end
  
end  