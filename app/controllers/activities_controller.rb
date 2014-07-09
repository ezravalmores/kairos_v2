class ActivitiesController < ApplicationController
  
  def index
    @activities = PublicActivity::Activity.order("created_at desc")  
  end
  
  def calendar
    @activities = PublicActivity::Activity.all.group("trackable_id") 
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
  end  
  
  def has_seen
    @public_activity = PublicActivity::Activity.find(params[:id])
    @public_activity.has_seen = true
    @public_activity.save    
  end  
  
end
