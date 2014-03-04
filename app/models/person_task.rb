class PersonTask < ActiveRecord::Base
  belongs_to :person
  belongs_to :task
  belongs_to :specific_task
  
  #attr_accessible :activity_id, :specific_activity_id
  
  #boolean methods
  def is_approved?
    is_approved == true
  end
  
  #class methods
  def self.calculate_total_hours(ids,show=nil)
   # ids = activities.map {|c| c.id}
    hours = 0
    minutes = 0
    seconds = 0
    activities = find(ids)
    activities.each do |f|
      
      should_change_seconds = "false"
      should_change_minutes = "false" 
      
      seconds += f.total_time.strftime('%S').to_i if !f.total_time.nil?
      if seconds >= 60
        should_change_seconds = "true"
      end
      minutes += f.total_time.strftime('%M').to_i if !f.total_time.nil?
      if minutes >= 60
        should_change_minutes = "true" 
      end 
      if should_change_seconds == "true" 
        minutes += 1
        seconds = seconds - 60
      end
      if should_change_minutes == "true" 
        hours += 1
        minutes = minutes - 60
      end
      hours += f.total_time.strftime('%H').to_i if !f.total_time.nil?     
    end
    if show =="hours"
      hours
    elsif show =="minutes"
      minutes
    else
      seconds  
    end
  end
  
  def self.search(search,time,current_user)
    if !search.blank?
      start = search + " " + "00:00:00"
      endt = search + " " + "23:59:59"
      where(["person_tasks.start >=? AND person_tasks.start <=? AND person_id =?",start,endt,current_user.id]).order("start DESC").includes(:task, :specific_task) 
    else
      where(["person_tasks.start >=? AND person_tasks.start <=? AND person_id =?",time.beginning_of_day,time.end_of_day,current_user.id]).order("start DESC").includes(:task, :specific_task)  
    end    
  end  
  
  def self.fetch_productive_hours(search,time,current_user)
    personal_id = Task.find_by_name("Personal Time").id
    break_id = Task.find_by_name("Break").id
    avail_id = Task.find_by_name("Avail Time").id
    
    @tasks = search(search,time,current_user)
    
    @tasks.where(["person_tasks.task_id !=? AND person_tasks.task_id !=? AND person_tasks.task_id !=?",break_id,personal_id,avail_id])
  end
  
  def self.fetch_break_hours(search,time,current_user)
    @break_id = Task.find_by_name("Break").id
    
    @tasks = search(search,time,current_user)
    @tasks.where(["person_tasks.task_id =?",@break_id])
  end
  
  def self.fetch_unfinished_tasks_today(search,time,current_user)
    @tasks = search(search,time,current_user)
    @tasks = @tasks.where(["task_id IS NULL"]).order("start DESC").includes(:task, :specific_task)
  end
  
end  