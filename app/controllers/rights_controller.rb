class RightsController < ApplicationController
  before_filter :authorize
  
  
  def index
    @rights = Right.all
  end
  
  def edit
    
  end
  
  def new
    @right = Right.new
  end
  
  def create
     @right = Right.new(right_params)

      respond_to do |format|
        if @right.save
          flash[:notice] = 'Right was successfully created.'
          format.html { redirect_to(rights_url) }
        else
          format.html { render :new }
        end
      end    
  end
  
  def update
      @right = Right.find(params[:id])

      respond_to do |format|
        if @right.update_attributes(right_params)

            flash[:notice] = 'Right was successfully updated.'
            format.html { redirect_to(rights_url) } 

        else
          format.html { render :edit }
        end
      end
  end        
 
 def right_params
   params.require(:right).permit(:role_id, :action, :context)   
 end 
  
end  