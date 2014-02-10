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
        flash[:notice] = 'Person was successfully updated.'
        format.html { redirect_to(people_url) }
      else
        format.html { render :edit }
      end
    end
  end
  
  def destroy
    
  end        
  
  private
  
  def user_params
    params.require(:person).permit(:first_name, :last_name, :email_address, :time_zone, :role_id)
  end
end
