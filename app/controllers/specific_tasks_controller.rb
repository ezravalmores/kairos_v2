class SpecificTasksController < ApplicationController
  before_filter :authorize
  
  def index
    @specific_tasks = SpecificTask.fetch_specific_tasks(current_user.organization,current_user.role,current_user.department)
    @organization_roles = OrganizationRole.all
    @departments = Department.all  
    @tasks_assigned = department_role_tasks
  end  
  
  def new
     @specific_task = SpecificTask.new  
  end  

  def edit
     @specific_task = SpecificTask.find(params[:id])  
  end

   # POST /specific_tasks
  def create
    @specific_task = SpecificTask.new(specific_task_params)

    respond_to do |format|
      if @specific_task.save
        flash[:notice] = 'Specific tasks was successfully created.'
        format.html { redirect_to(specific_tasks_url) }
      else
        format.html { render :new }
      end
    end
  end
  
  def update
    @specific_task = SpecificTask.find(params[:id])

    respond_to do |format|
      if @specific_task.update_attributes(specific_task_params)
         @specific_task.role_specific_tasks.update_all(:name => @specific_task.name)
        flash[:notice] = 'Task was successfully updated.'
        format.html { redirect_to(specific_tasks_url) }
      else
        format.html { render :edit }
      end
    end
  end
  
  def get_specific_tasks_assignments
    @specific_task = SpecificTask.find(params[:id])
    @specific_tasks_assignments = RoleSpecificTask.where('organization_id =? AND specific_task_id =?',current_user.organization_id, params[:id])  
  end
  
  def get_role_task
    @role_task = RoleTask.find(params[:id])
    #@assignments = RoleTask.where('organization_id =? AND task_id =?',current_user.organization_id, params[:id])  
  end
  
  def create_specific_role_task
    @specific_tasks_assignments = RoleSpecificTask.where('organization_id =? AND specific_task_id =?',current_user.organization_id, params[:specific_task]) 
    
    @count = RoleSpecificTask.where('organization_id =? AND department_id =? AND organization_role_id =? AND specific_task_id =?',current_user.organization_id.to_i,params[:department].to_i,params[:organization_role].to_i,params[:specific_task].to_i).count
    
    if @count > 0
      flash[:warning] = "Specific Task assignment was already existing"
    else
      @role_specific_task = RoleSpecificTask.create!(:organization_id => current_user.organization.id, :department_id => params[:department], :organization_role_id => params[:organization_role],:role_task_id => params[:role_task], :specific_task_id => params[:specific_task], :name => params[:name])
      flash[:notice] = "Specific Task assignment was successfully created!"
    end
    
  end
  
  def deactivate_role_specific_task
    @role_specific_task = RoleSpecificTask.find(params[:id])
    @role_specific_task.is_active = false
    @role_specific_task.save
    
    @specific_tasks_assignments = RoleSpecificTask.where('organization_id =? AND specific_task_id =?',current_user.organization_id, params[:specific_task]) 
  end  
  
  def activate_role_specific_task
    @role_specific_task = RoleSpecificTask.find(params[:id])
    @role_specific_task.is_active = true
    @role_specific_task.save
    
    @specific_tasks_assignments = RoleSpecificTask.where('organization_id =? AND specific_task_id =?',current_user.organization_id, params[:specific_task]) 
  end
  
  private
  def specific_task_params
     params.require(:specific_task).permit(:name, :description, :organization_id, :department_id)
  end
  
end  