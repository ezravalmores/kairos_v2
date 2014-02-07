class PersonTasksController < ApplicationController
  require 'time_diff'
  before_filter :authorize
      
  def index
    session[:search] = nil
    session[:time] = nil
    session[:user] = nil
    
    @tasks = PersonTask.search(params[:search],set_user_time_zone,current_user).includes(:task, :specific_task)
    @productive = PersonTask.fetch_productive_hours(params[:search],set_user_time_zone,current_user).includes(:task, :specific_task)
    
    @break = PersonTask.fetch_break_hours(params[:search],set_user_time_zone,current_user).includes(:task, :specific_task)
    
    @unfinished = PersonTask.fetch_unfinished_tasks_today(params[:search],set_user_time_zone,current_user).includes(:task, :specific_task)
    
    session[:search] = params[:search]
    
  end    
  
  def edit
    
  end
  
  def show
    
  end
  
  def create
    
  end
  
  def update
    @task = PersonTask.find(params[:id])
    if @task.update_attributes(user_params)
      @task.end = set_user_time_zone
      @task.save
      
      difference = Time.diff(Time.parse(@task.start.strftime('%Y-%m-%d  %H:%M:%S')), Time.parse(@task.end.strftime('%Y-%m-%d %H:%M:%S')), '%h:%m:%s')
      total_time = difference[:hour].to_s + ":" + difference[:minute].to_s + ":" + difference[:second].to_s

      @task.total_time = total_time
      @task.save
      
      @tasks = PersonTask.search(session[:search],set_user_time_zone,current_user).includes(:task, :specific_task)
      @productive = PersonTask.fetch_productive_hours(session[:search],set_user_time_zone,current_user).includes(:task, :specific_task)

      @break = PersonTask.fetch_break_hours(session[:search],set_user_time_zone,current_user).includes(:task, :specific_task)
      @unfinished = PersonTask.fetch_unfinished_tasks_today(session[:search],set_user_time_zone,current_user).includes(:task, :specific_task)
      
      if params[:end_shift] == 'yes'
        new_activity = PersonTask.create!(:person_id => current_user.id,:start => @task.end,:created_at => set_user_time_zone) 
      end
      
      respond_to do |format| 
        format.html {redirect_to person_times_url}
        format.js
        flash[:notice] = "Your activity was successfully ended!" 
      end    
    end   
  end
  
  def destroy
    
  end  
  
  def submit_tasks
    @tasks = PersonTask.search(session[:search],set_user_time_zone,current_user).includes(:task, :specific_task)
    @tasks.update_all(:is_submitted => true)  
    
    @people = Person.find(params[:people])
    
    if session[:search].blank?
      shift_date = set_user_time_zone.strftime('%Y-%m-%d')
    else
      shift_date = session[:search]
    end
  
    for person in @people
      KairosMailer.send_approvals(person,current_user,shift_date).deliver
    end
    
    respond_to do |format|
      format.js   { render :nothing => true } 
    end
  end  
  
  private

  def user_params
    params.require(:person_task).permit(:person_id, :task_id, :specific_task_id, :person_in_charge, :note, :start_test)
  end         
end  
  