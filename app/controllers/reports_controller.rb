class ReportsController < ApplicationController
require 'will_paginate/array' 

  before_filter :authorize

  # GET /report
   def tasks_report
     @search = Search.new
     session[:person_task_search_cache] = nil
     session[:person_task_search_results] = nil
     session[:form_type] = 'basic_form'
     respond_to do |format|
       format.html { render :layout => 'application' } # index.html.erb
     end
   end
   
   def search_tasks
       @search = fetch_search(:person_task)
       session[:form_type] = params[:form_type]
       if @search.is_cached?
         # Search from the search cache
         @person_tasks = session[:person_task_search_results].nil? ?
           @search.find_tasks_new([:task,:specific_task,{:person => [:department, :organization] }]) :
           PersonTask.find(session[:person_task_search_results],
             :include => [:task,:specific_task, {:person => [:department, :organization] }],
             :order => 'person_tasks.start DESC,person_tasks.person_id')
         @total_count = @person_tasks.length    
         #@person_tasks = @person_tasks.collect
         @person_tasks = @person_tasks.paginate(:page => params[:page],:per_page => 100)   

       elsif @search.is_active?
         # Search from scratch
         @person_tasks = @search.find_tasks_new([:task,:specific_task,{:person => [:department, :organization] }])
         if @person_tasks.length >=1 && @person_tasks.length <= 1000
           session[:person_task_search_cache] = params[:search]
           #ids = @person_tasks.collect.map {|p| p.id}
           #session[:person_task_search_results] = ids
         else
           session[:person_task_search_cache] = nil
           session[:person_task_search_results] = nil
         end
         @total_count = @person_tasks.length 
        #person_tasks = @person_tasks.collect

        @person_tasks = @person_tasks.paginate(:page => params[:page],:per_page => 100)    
       else
         # Nothing to search
         flash[:warning] = "You must enter something to search for" if request.post?
       end

       respond_to do |format|
         format.html {
             render :layout => 'application'
         }
       end   
   end
   
   def generate_spreadsheets
      spreadsheets = {}
       @search = fetch_search(:person_task)
        tasks = session[:person_task_search_results].nil? ?
           @search.find_tasks_new([:task,:specific_task,{:person => [:department, :organization] }]) :
           PersonTask.find(session[:person_task_search_results],
             :include => [:task,:specific_task, {:person => [:department, :organization] }],
             :order => 'person_tasks.start DESC,person_tasks.person_id')
        template = "reports/tasks_report.xls.eku"  
        @tasks_or_rates = tasks
        @report_type = "tasks_report"
        spreadsheets["tasks_report.xls"] = 
        render_to_string(:template => template)
                
        public_filename = Archiver.bundle(spreadsheets,@report_type)

        send_file(File.join("public",public_filename), :disposition => 'attachment') 
   end        
   
   def utilization_rates
      @search = Search.new
      session[:search_rate_search_cache] = nil
      session[:search_rate_search_results] = nil

      respond_to do |format|
        format.html { render :layout => 'application' } # index.html.erb
      end
   end
   
   def search_rates
     @search = fetch_search(:utilization_rate)
      if @search.is_cached?
        # Search from the search cache
        @utilization_rates = session[:utilization_rate_search_results].nil? ?
         @search.find_rates([{:person => [:department, :organization]}]) :
          UtilizationRate.find(session[:utilization_rate_search_results],
            :include => [{:person => [:department, :organization]}],
            :order => 'utilization_rates.shift_date DESC,utilization_rates.person_id')
        @total_count = @person_tasks.length    
        #@person_tasks = @person_tasks.collect
        @utilization_rates = @utilization_rates.paginate(:page => params[:page],:per_page => 100)   

      elsif @search.is_active?
        # Search from scratch
        @utilization_rates = @search.find_rates([{:person => [:department, :organization]}])
        if @utilization_rates.length >=1 && @utilization_rates.length <= 1000
          session[:utilization_rates_search_cache] = params[:search]
          #ids = @person_tasks.collect.map {|p| p.id}
          #session[:person_task_search_results] = ids
        else
          session[:utilization_rates_search_cache] = nil
          session[:utlization_rates_search_results] = nil
        end
        @total_count = @utilization_rates.length 
       #person_tasks = @person_tasks.collect

       @utilization_rates = @utilization_rates.paginate(:page => params[:page],:per_page => 100)    
      else
        # Nothing to search
        flash[:warning] = "You must enter something to search for" if request.post?
      end

      respond_to do |format|
        format.html {
            render :layout => 'application'
        }
      end   
   end  
end  