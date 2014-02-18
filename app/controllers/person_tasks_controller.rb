class PersonTasksController < ApplicationController
  require 'time_diff'
  include ActionView::Helpers::NumberHelper
  
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
    @task = PersonTask.find(params[:id])
  end
  
  def show
    
  end
  
  def create
    
  end
  
  def update
    @task = PersonTask.find(params[:id])
    
    if params[:from] == 'task manager'
    
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
          flash[:notice] = "Your activity was successfully ended!" 
          format.js
        end    
      end
    else
       @task.update_attributes(user_params)  
       if !@task.end.nil?
         difference = Time.diff(Time.parse(@task.start.strftime('%Y-%m-%d  %H:%M:%S')), Time.parse(@task.end.strftime('%Y-%m-%d %H:%M:%S')), '%h:%m:%s')
         total_time = difference[:hour].to_s + ":" + difference[:minute].to_s + ":" + difference[:second].to_s

         @task.total_time = total_time
         @task.save
         
         @tasks = PersonTask.search(session[:search],set_user_time_zone,current_user).includes(:task, :specific_task)
         @productive = PersonTask.fetch_productive_hours(session[:search],set_user_time_zone,current_user).includes(:task, :specific_task)

         @break = PersonTask.fetch_break_hours(session[:search],set_user_time_zone,current_user).includes(:task, :specific_task)
         @unfinished = PersonTask.fetch_unfinished_tasks_today(session[:search],set_user_time_zone,current_user).includes(:task, :specific_task)
       end
       respond_to do |format|   
         format.html {redirect_to person_tasks_url}
         flash[:notice] = "Your task was successfully updated!"  
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
   
    @total_hour = UtilizationRate.where(["shift_date =? AND person_id =?",shift_date,current_user.id])
    @productive_hours = PersonTask.fetch_productive_hours(params[:search],set_user_time_zone,current_user).includes(:task, :specific_task)
    
    @hours = PersonTask.calculate_total_hours(@productive_hours.map {|a| a.id},"hours")
    @minutes = PersonTask.calculate_total_hours(@productive_hours.map {|a| a.id},"minutes")
    
    @th = number_with_precision(UtilizationRate.save_utilization_rate(@hours,@minutes),:precision => 2)
    
    if @total_hour.count == 0    
      UtilizationRate.create!(:person_id => current_user.id,:total_utilization_rate => @th, :shift_date => shift_date)
    else
      @total_hour.last.total_utilization_rate = @th.to_f
      @total_hour.last.save
    end
      
    for person in @people
      KairosMailer.send_approvals(person,current_user,shift_date).deliver
    end
    
    respond_to do |format|
      flash[:notice] = "Today Tasks was successfully submitted!" 
      format.js   { } 
    end
  end  
  
  private

  def user_params
    params.require(:person_task).permit(:person_id, :task_id, :specific_task_id, :person_in_charge, :note, :start,:end)
  end         
end  
  