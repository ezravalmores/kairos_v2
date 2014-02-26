class ReportsController < ApplicationController
  
  # GET /children
   def tasks_report
     @search = Search.new
     session[:person_task_search_cache] = nil
     session[:person_task_search_results] = nil

     respond_to do |format|
       format.html { render :layout => 'application' } # index.html.erb
     end
   end
   
   def search_tasks
       @search = fetch_search(:person_task)

       if @search.is_cached?
         # Search from the search cache
         @person_tasks = session[:person_task_search_results].nil? ?
           @search.find_tasks([:person_task,:specific_task,{:person => [:department, :organization] }]) :
           PersonTask.find(session[:person_task_search_results],
             :include => [:task,:specific_task, :person],
             :order => 'person_tasks.person_id')
         @total_count = @person_tasks.length    
         @person_tasks = @person_tasks.collect
         #@person_tasks = @person_tasks.paginate(:page => params[:page],:per_page => 100)   

       elsif @search.is_active?
         # Search from scratch
         @person_tasks = @search.find_tasks([:task,:specific_task,{:person => [:department, :organization] }])
         if @person_tasks.length == 1 || @person_tasks.length <= 1000
           session[:person_task_search_cache] = params[:search]
           session[:person_task_search_results] = @person_tasks.sort_by { |s| [s.person_id] }.collect { |t| t.id }
         else
           session[:person_task_search_cache] = nil
           session[:person_task_search_results] = nil
         end
         @total_count = @person_tasks.length 
         @person_tasks = @person_tasks.collect

         #@children = @children.paginate(:page => params[:page],:per_page => 100)    
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