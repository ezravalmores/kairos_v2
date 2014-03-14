class ApplicationController < ActionController::Base
  #extend ActiveSupport::Memoizable

  helper :all # include all helpers, all the time
  include RedirectBack
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :set_user_time_zone
  #before_filter :authorize
  
  unless Rails.application.config.consider_all_requests_local
    rescue_from ActiveRecord::RecordNotFound, :with => :redirect_to_application_url
  end
  
  def index   
    if current_user     
      redirect_to dashboard_url
    else
      redirect_to login_url
    end
  end
  
  protected
  
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
    def admin?
      current_user.admin?
    end
  
    def authorize
      if current_user
        unless current_user.has_right?(action_name,controller_path)
          logger.error("#{current_user.email_address} does not have rights to access #{controller_path} > #{action_name}.")
          #request.env["HTTP_REFERER"] ? (redirect_to :back) : (redirect_to person_tasks_url)
          
          redirect_to_back_or_dashboard
          
          return false
        end
      else
        store_return_point
        redirect_to login_url
        return false
      end
      return true
    end
  
  def fetch_search(object)
    from_cache = false
    cache = (object.to_s + "_search_cache").to_sym
  
    if params[:search]
      attributes = params[:search]
      from_cache = true if params[:search] == session[cache]
    elsif session[cache]
      attributes = session[cache]
      from_cache = true
    end
  
    @current_search = Search.new(attributes)
    @current_search.cached = from_cache
    return @current_search
  end
  
  
  def fetch_tasks_today(*associations)
    @start = set_user_time_zone.beginning_of_day
    @end = set_user_time_zone.end_of_day
    @tasks = PersonTask.where(["person_tasks.start >=? AND person_tasks.start <=? AND person_id =?",@start,@end,current_user.id]).order("start DESC").includes(:task, :specific_task) 
  end
  
  def fetch_people_that_can_approve
    @people = Person.can_approve.all  
  end  
  
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
  
  def redirect_to_back_or_dashboard
    respond_to do |format|
      format.html{
        request.env["HTTP_REFERER"] ? (redirect_to :back, :alert => 'You are not authorize.....') : (redirect_to dashboard_url, :alert => 'You are not authorize.....')
      }
    end
  end  
  
end
