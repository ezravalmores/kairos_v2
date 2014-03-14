class LoginController < ApplicationController

  def login
    #session[:user_id] = nil
    if request.post?
 
        @user = Person.authenticate(params[:username],params[:password])
        
        if @user
          if Time.now.strftime('%H:%M:%S') >= @user.start_time.strftime('%H:%M:%S')
            session[:user_id] = @user.id
            activities_today ||= user_tasks_today

            PersonTask.create!(:person_id => current_user.id, :start_time => Time.now.utc, :created_at => Time.now.utc, :updated_at => Time.now.utc, :shift_date => session[:shift_date], :start => set_user_time_zone) if activities_today.length == 0
            redirect_to dashboard_path
          else
            reset_session
            redirect_to :action => :login
            flash[:warning] = "Sorry, you can't login at the moment, wait for your shift to start"
          end
        else
          flash[:warning] = "Username or Password incorrect!"
        end
 
    end
  end
  
  def logout
    reset_session
    redirect_to login_url
  end
  
  def set_date
    activities_today ||= user_tasks_today
    
    unless params[:set_date].nil?
      PersonTime.create!(:person_id => current_user.id, :start_time => Time.now.utc, :created_at => Time.now.utc, :updated_at => Time.now.utc) if activities_today.length == 0
      redirect_to person_times_url
    end
  end  
  
end
