class TasksController < ApplicationController
  before_filter :authorize
  
  def index
    @task = Task.new  
    @tasks = Task.fetch_tasks(current_user.organization,current_user.role,current_user.department)
    @organization_roles = OrganizationRole.all
    @departments = Department.all
  end
  
  def new
    @task = Task.new  
  end  
  
  def edit 
    @task = Task.find(params[:id])
  end
  
  # POST /tasks
   def create
     @task = Task.new(task_params)
     
     respond_to do |format|
       if @task.save
         flash[:notice] = 'Tasks was successfully created.'
         format.html { redirect_to(tasks_url) }
       else
         format.html { render :new }
       end
     end
   end  
  
  
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(task_params)
        @task.role_tasks.update_all(:name => @task.name)
        flash[:notice] = 'Task was successfully updated.'
        format.html { redirect_to(tasks_url) }
      else
        format.html { render :edit }
      end
    end
  end
  
  
  def get_tasks_assignments
    @task = Task.find(params[:id])
    @assignments = RoleTask.where('organization_id =? AND task_id =?',current_user.organization_id, params[:id])  
  end  
  
  def create_role_task
    @assignments = RoleTask.where('organization_id =? AND task_id =?',current_user.organization_id, params[:task]) 
    @count = RoleTask.where('organization_id =? AND department_id =? AND organization_role_id =? AND task_id =?',current_user.organization_id.to_i,params[:department].to_i,params[:organization_role].to_i,params[:task].to_i).count
    
    if @count > 0
      flash[:warning] = "Task assignment was already existing"
    else
      @role_task = RoleTask.create!(:organization_id => current_user.organization.id, :department_id => params[:department], :organization_role_id => params[:organization_role], :task_id => params[:task], :name => params[:name])
      flash[:notice] = "Task assignment was successfully created!"
    end
    
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
  def task_params
     params.require(:task).permit(:name, :description, :organization_id, :department_id)
   end
end  