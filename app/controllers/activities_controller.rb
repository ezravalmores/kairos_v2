class ActivitiesController < ApplicationController
  
  def index
    @activities = PublicActivity::Activity.order("created_at desc")  
  end
  
  def calendar
    @leaves = PublicActivity::Activity.where('trackable_type =?',"Leave").group("trackable_id") 
    @events = PublicActivity::Activity.where('trackable_type =?',"Event") 
    @activities = @leaves + @events
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
  end  
  
  def has_seen
    @public_activity = PublicActivity::Activity.find(params[:id])
    @public_activity.has_seen = true
    @public_activity.save    
  end  
  
end
