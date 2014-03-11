class PersonTask < ActiveRecord::Base  
  include PublicActivity::Common
  belongs_to :person
  belongs_to :task
  belongs_to :specific_task
  
  #attr_accessible :activity_id, :specific_activity_id
  
  #boolean methods
  def is_submitted?
    is_submitted == true && is_disapproved == false && is_approved == false
  end
  
  def is_approved?
    is_submitted == true && is_approved == true && is_disapproved == false
  end
  
  def is_disapproved?
    is_submitted == true && is_disapproved == true && is_approved == false
  end
  
  
  #class methods
  def self.find_tasks_to_be_approved(person,*associations,user)
    associations = []
    where = Where.new
    
    if user.is_admin?
      if !person.blank?
        
        where.and('organizations.name LIKE ?', "%#{user.organization.name}%") 
        where.and('person_tasks.person_id = ?',person) 
      else
        where.and('organizations.name LIKE ?', "%#{user.organization.name}%")
      end
    else
      if !person.blank?  
        where.and('departments.name LIKE ?', "%#{user.department.name}%") 
        where.and('organizations.name LIKE ?', "%#{user.organization.name}%")
        where.and('person_tasks.person_id = ?',person) 
      else
        where.and('departments.name LIKE ?', "%#{user.department.name}%") 
        where.and('organizations.name LIKE ?', "%#{user.organization.name}%")     
      end     
    end
   
    where.and('person_tasks.is_submitted = ? AND (person_tasks.is_approved = ? OR person_tasks.is_disapproved = ?)', "1", "0", "1")
    
    associations << [:task,:specific_task,{:person => [:department, :organization] }]
    person_tasks = PersonTask.scoped({})
    
    person_tasks = person_tasks.all(:include => associations.uniq,:conditions => where.to_s, :order =>'person_tasks.start DESC, person_tasks.person_id')  
  end
  
  def self.approve_tasks(ids,current_user)
    person_tasks = where(:id => ids)    
    for person_task in person_tasks
      person_task.approve_task(person_task,current_user)  
    end  
  end  
  
  def approve_task(person_task,current_user)
    if !person_task.task_id.nil? && !person_task.specific_task_id.nil?
      person_task.is_approved = true
      person_task.is_disapproved = false
      person_task.approved_by = current_user.id
      person_task.save!  
    end
  end  
  
  def self.disapprove_tasks(ids,current_user)
    person_tasks = where(:id => ids)    
    for person_task in person_tasks
      person_task.disapprove_task(person_task,current_user)  
    end  
  end  
  
  def disapprove_task(person_task,current_user)
    if !person_task.task_id.nil? && !person_task.specific_task_id.nil?
      person_task.is_approved = false
      person_task.is_disapproved = true
      person_task.approved_by = current_user.id
      person_task.save!  
    end
  end
  
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