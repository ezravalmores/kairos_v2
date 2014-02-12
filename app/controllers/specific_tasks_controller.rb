class SpecificTasksController < ApplicationController
  before_filter :authorize
  
  def index
    @specific_tasks = SpecificTask.all
    @organization_roles = OrganizationRole.all
    @departments = Department.all  
    @tasks_assigned = department_role_tasks
  end  
  
  def new
     @specific_task = SpecificTask.new  
  end  


   # POST /specific_tasks
    def create
      @specific_task = SpecificTask.new(user_params)

      respond_to do |format|
        if @specific_task.save
          flash[:notice] = 'Specific tasks was successfully created.'
          format.html { redirect_to(specific_tasks_url) }
        else
          format.html { render :index }
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
  
end  