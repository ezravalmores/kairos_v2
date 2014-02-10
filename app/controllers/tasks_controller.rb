class TasksController < ApplicationController
  before_filter :authorize
  
  def index
    @task = Task.new  
    @tasks = Task.all
    @organization_roles = OrganizationRole.all
    @departments = Department.all
  end
  
  def new
    @task = Task.new  
  end  
  
  
  # POST /tasks
   def create
     @task = Task.new(user_params)
     
     respond_to do |format|
       if @task.save
         flash[:notice] = 'Tasks was successfully created.'
         format.html { redirect_to(tasks_url) }
       else
         format.html { render :index }
       end
     end
   end  
  
  def get_tasks_assignments
    @task = Task.find(params[:id])
    @assignments = RoleTask.where('organization_id =? AND task_id =?',current_user.organization_id, params[:id])  
  end  
  
  def create_role_task
    @assignments = RoleTask.where('organization_id =? AND task_id =?',current_user.organization_id, params[:task]) 
    @role_task = RoleTask.create!(:organization_id => current_user.organization.id, :department_id => params[:department], :organization_role_id => params[:organization_role], :task_id => params[:task], :name => params[:name])
  end  
  
  def deactivate_role_task
    @role_task = RoleTask.find(params[:id])
    @role_task.is_active = false
    @role_task.save
    
    @assignments = RoleTask.where('organization_id =? AND task_id =?',current_user.organization_id, params[:task]) 
  end  
  
  def activate_role_task
    @role_task = RoleTask.find(params[:id])
    @role_task.is_active = true
    @role_task.save
    
    @assignments = RoleTask.where('organization_id =? AND task_id =?',current_user.organization_id, params[:task]) 
  end
  
  
  private
  def user_params
     params.require(:task).permit(:name, :description)
   end
end  