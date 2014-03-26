class LeavesController < ApplicationController
  
  before_filter :authorize
  
  def index
    @leaves = current_user.leaves
  end
  
  def new
    @leave = Leave.new
  end
  
  def edit
    @leave = Leave.find(params[:id])
  end
  
  def create
    @leave = Leave.new(leave_params)

    respond_to do |format|
      if @leave.save
        @leave.create_activity :create, owner: current_user , date: @leave.date
        
        flash[:notice] = 'Leave was successfully created.'
        format.html { redirect_to(leaves_url) }
      else
        format.html { render :new }
      end
    end
  end
  
  def update
    @Leave = Leave.find(params[:id])

    respond_to do |format|
      if @Leave.update_attributes(leave_params)
      
          flash[:notice] = 'Leave was successfully updated.'
          format.html { redirect_to(leaves_url) } 
        
      else
        format.html { render :edit }
      end
    end
  end
  
  def destroy
    @leave = Leave.find(params[:id])
    @leave.destroy

    flash[:notice] = "Leave request has been deleted"

    respond_to do |format|
      format.html { redirect_to(leaves_url) }
    end
  end          
  
  def submit_leaves
    @submitted_leaves = Leave.where(:id => params[:leaves])
    @submitted_leaves.update_all(:is_submitted => true)  
    
    @people = Person.find(params[:people])
      
    for person in @people
      KairosMailer.submit_leaves(person,current_user,@submitted_leaves).deliver
      for leave in @submitted_leaves
        leave.create_activity :submit_leaves, owner: current_user, recipient: person, date: leave.date
      end
    end
    @leaves = current_user.leaves

    respond_to do |format|
      flash[:notice] = "Leaves was successfully submitted!" 
      format.js {} 
    end
  end
  
  private
  
  def leave_params 
    params.require(:leave).permit(:date,:Leave_id,:leave_type_id,:reason,:person_id)
  end
  
end
