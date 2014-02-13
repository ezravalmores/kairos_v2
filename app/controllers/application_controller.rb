class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

    
  protect_from_forgery with: :exception
  #before_filter :authorize
  before_filter :set_user_time_zone
  #before_filter :authorize
  
  unless Rails.application.config.consider_all_requests_local
    rescue_from ActiveRecord::RecordNotFound, :with => :redirect_to_application_url
  end
  
  def index   
    if current_user     
      redirect_to person_tasks_url
    else
      redirect_to login_url
    end
  end
  
  protected
  
  def authorize
    if current_user
      application_url
    else
      redirect_to root_url
      flash[:warning] = "You are not authorize!"
    end
  end
  
  def set_user_time_zone
    timezone = Timezone::Zone.new :zone => current_user.time_zone if current_user
    timezone.time Time.now if current_user
  end
  helper_method :set_user_time_zone
  
  def current_user
     @current_user ||= fetch_user
  end
  helper_method :current_user
  
  def fetch_user
    Person.find(session[:user_id]) unless session[:user_id].nil?
  end
  
  def user_tasks_today
    @tasks ||= fetch_tasks_today  
  end  
  helper_method :user_tasks_today
  
  def user_unfinished_tasks_today
    @unfinished_tasks ||= fetch_unfinished_tasks_today  
  end  
  helper_method :user_unfinished_tasks_today
  
  def people_that_can_approve
    @people ||= fetch_people_that_can_approve  
  end  
  helper_method :people_that_can_approve
  
  def productive_hours
    @productive_hours ||= fetch_productive_hours
  end  
  helper_method :productive_hours
  
  def break_hours
    @break_hours ||= fetch_break_hours
  end  
  helper_method :break_hours
  
  def role_tasks
    @role_tasks ||= fetch_role_tasks
  end  
  helper_method :role_tasks
  
  def role_specific_tasks
    @role_specific_tasks ||= fetch_specific_role_tasks
  end  
  helper_method :role_specific_tasks
  
  def department_role_tasks
    @department_role_tasks ||= fetch_department_role_tasks
  end
  helper_method :department_role_tasks
  
  def positions
    @positions ||= fetch_positions
  end  
  helper_method :positions
  
  def departments
    @org_departments ||= fetch_departments
  end  
  helper_method :departments
  
  private
  
  def fetch_tasks_today(*associations)
    @start = set_user_time_zone.beginning_of_day
    @end = set_user_time_zone.end_of_day
    @tasks = PersonTask.where(["person_tasks.start >=? AND person_tasks.start <=? AND person_id =?",@start,@end,current_user.id]).order("start DESC").includes(:task, :specific_task) 
  end
  
  #def fetch_unfinished_tasks_today
  #  @start = set_user_time_zone.beginning_of_day
  #  @end = set_user_time_zone.end_of_day
  #  @tasks = PersonTask.where(["person_tasks.start >=? AND person_tasks.start <=? AND person_id =? AND task_id IS NULL",@start,@end,current_user.id]).order("start DESC").includes(:task, :specific_task)
  #end  
  
  #def fetch_productive_hours
  #  personal_id = Task.find_by_name("Personal Time").id
  #  break_id = Task.find_by_name("Break").id
  #  avail_id = Task.find_by_name("Avail Time").id
    
  #  @tasks = fetch_tasks_today
    
  #  @tasks.where(["person_tasks.task_id !=? AND person_tasks.task_id !=? AND person_tasks.task_id !=?",break_id,personal_id,avail_id])
  #end
  
  #def fetch_break_hours
  #  break_id = Task.find_by_name("Break").id
  #  
  #  @tasks = fetch_tasks_today
  #  @tasks.where(["person_tasks.task_id =?",break_id])
  #end
  
  def fetch_people_that_can_approve
    @people = Person.can_approve.all  
  end  
  
  #def fetch_total_hours  
  #  
  #end
  
  def fetch_role_tasks
    @role = current_user.organization_role
    @organization = current_user.organization
    @department = current_user.department
    
    RoleTask.where('organization_id =? AND department_id =? AND organization_role_id =? AND is_active =?', @organization.id,@department.id,@role.id,true)
  end
  
  def fetch_department_role_tasks
     @organization = current_user.organization
     @department = current_user.department

     RoleTask.where('organization_id =? AND department_id =? AND is_active =?', @organization.id,@department.id,true)
   end
  
  def fetch_specific_role_tasks
    @role = current_user.organization_role
    @organization = current_user.organization
    @department = current_user.department

    RoleSpecificTask.where('organization_id =? AND department_id =? AND organization_role_id =? AND is_active =?', @organization.id,@department.id,@role.id,true)
  end  
  
  def fetch_positions
    OrganizationRole.organization_roles(current_user.organization)
  end  
  
  def fetch_departments
    Department.departments(current_user.organization,current_user.role,current_user.department)
  end  
end
