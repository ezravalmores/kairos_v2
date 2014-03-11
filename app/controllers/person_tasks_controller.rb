class PersonTasksController < ApplicationController
  require 'time_diff'
  include ActionView::Helpers::NumberHelper
  include PublicActivity::StoreController
  
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
  
  def dashboard
    @activities = PublicActivity::Activity.order("created_at desc").where(recipient_id: current_user.id)   
  end  
  
  def edit
    @task = PersonTask.find(params[:id])
  end
  
  def end_task
    
    unless params[:person_task][:task_id].blank?
    @message = 'Successfully ended!'
    @task = PersonTask.find(params[:person_task][:id])
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
      end
    else
      @message = 'Select a task first!'
      flash[:warning] = @message 
    end
      
    respond_to do |format| 
      format.js
    end    

  end  
  
  def update
    @task = PersonTask.find(params[:id])
      if @task.update_attributes(user_params)  
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
         format.html {redirect_to search_tasks_url}
         flash[:notice] = "Your task was successfully updated!"  
       end  
    end     
  end
  
  def destroy
    @person_task = PersonTask.find(params[:id])
    @person_task.destroy

    respond_to do |format|
      flash[:notice] = "Activity was successfully deleted!"
      format.html { redirect_to :back }
    end  
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
    @productive_hours = PersonTask.fetch_productive_hours(shift_date,set_user_time_zone,current_user).includes(:task, :specific_task)
    
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
      #@public_activity = PublicActivity.create(owner_type: "Person", trackable_type: 'PersonTask', owner_id: current_user.id, key: 'person_task.submit_tasks')
      @tasks.first.create_activity :submit_tasks, owner: current_user, recipient: person, date: shift_date
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
  