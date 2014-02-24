class PeopleController < ApplicationController
  before_filter :authorize
  
  def index
    @people = Person.active.all

    respond_to do |format|
      format.html # index.html.erb
    end    
  end  
  
  def new
    @person = Person.new

    respond_to do |format|
      format.html # index.html.erb
    end
  end  
  
  def show
    
  end
  
  def edit
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def create
    @person = Person.new(user_params)
    #@person.created_by = current_user.id

    respond_to do |format|
      if @person.save
        #SproutMailer.welcome_message(@person).deliver
        flash[:notice] = 'Person was successfully created.'
        format.html { redirect_to(people_url) }
      else
        format.html { render :new }
      end
    end
  end  
  
  def update
    @person = Person.find(params[:id])

    respond_to do |format|
      if @person.update_attributes(user_params)
      
        
        if current_user.role.name == '2nd Level User'
          flash[:notice] = 'Your information was successfully updated!'
          format.html { redirect_to(person_tasks_url) }  
        else
          flash[:notice] = 'Person was successfully updated.'
          format.html { redirect_to(people_url) } 
        end  
        
      else
        format.html { render :edit }
      end
    end
  end
  
  def destroy
    
  end        
  
  private
  
  def user_params
    params.require(:person).permit(:first_name, :last_name, :email_address, :time_zone, :role_id, :organization_role_id, :department_id, :organization_id, :username, :password, :can_approve, :start_time, :end_time)
  end
end
