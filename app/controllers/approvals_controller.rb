class ApprovalsController < ApplicationController
  require 'will_paginate/array'
 
  before_filter :authorize
  
  def tasks_approval
    session[:person] = nil
    
    @for_approvals = PersonTask.find_tasks_to_be_approved(params[:person],[:task,:specific_task,{:person => [:department, :organization] }],current_user)
    
    @total_count = @for_approvals.length 

    @for_approvals = @for_approvals.paginate(:page => params[:page],:per_page => 100)
  end
  
end  