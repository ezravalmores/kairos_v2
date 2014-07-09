class EventsController < ApplicationController
   before_filter :authorize
  def index
    @events = Event.all
    
    respond_to do |format|
      format.html {}
    end 
  end
  
  def show
    @event = Event.find(params[:id])
    ids = @event.event_people
    @people = Person.where(:id => ids.split(','))
  end  
  
  def new
    @event = Event.new
  end
  
  def edit
    
  end
  
  def create
    @event = Event.new(event_params)
    @event.created_by = current_user.id
    @event.event_people = current_user.id
    
    respond_to do |format|
      if @event.save
        
        dt1 = @event.from.to_date
        dt2 = @event.to.to_date
        
        days_ctr = dt2 - dt1
        event_date = @event.from
        i = 1
        if days_ctr.to_i > 1
          days_ctr.to_i.times do
            @event.create_activity :submit_events, owner: current_user, date: event_date 
            event_date = event_date + 1.day 
          end
          @event.create_activity :submit_events, owner: current_user, date: @event.to 
        else
          @event.create_activity :submit_events, owner: current_user, date: event_date  
          @event.create_activity :submit_events, owner: current_user, date: @event.to     
        end  
        
        flash[:notice] = 'Event was successfully created and emailed people that you have selected.'
        format.html { redirect_to(events_url) }
      else
        flash[:warning] = 'warning.'
        format.html { render :new }
      end
    end
  end
  
  def update
    
  end
  
  def destroy
    @event = Event.find(params[:id])
    
    @activities = PublicActivity::Activity.all
    
    @activities = @activities.all(:conditions => ['trackable_id =? AND trackable_type =?',@event.id,'Event'])
    @activities.each{ |a| a.destroy }
    @event.destroy
    
    flash[:notice] = "event request has been deleted"

    respond_to do |format|
      format.html { redirect_to(events_url) }
    end
  end            
  
  def submit_events
    @submitted_events = Event.where(:id => params[:events])
    @submitted_events.update_all(:is_submitted => true)  
    
    @people = Person.find(params[:people])
    people_ids = @people.map {|p| p.id}.join(",")  
        
    for person in @people
      KairosMailer.create_event(person,current_user,@submitted_events,@people).deliver
    end
      
    for event in @submitted_events
      event.event_people = event.event_people + "," + people_ids
      event.save
      event.create_activity :submit_events, owner: current_user, date: event.date
    end  
    @events = Event.all

    respond_to do |format|
      flash[:notice] = "People was successfully notified."
      format.js {} 
    end
  end
  
  def remove_person
    @event = Event.find(params[:id])
    ids = @event.event_people
    remove = params[:person]
    ids = ids.gsub(remove.to_s,'')    
    
    @event.event_people = ids
    @event.save
    
    @people = Person.where(:id => ids.split(','))
    
    @person = Person.find(remove)
    KairosMailer.remove_person(@person,current_user,@event).deliver
    
    respond_to do |format|
      flash[:notice] = "Person was successfully removed."
      format.js {} 
    end
  end
  
  private
  
  def event_params 
    params.require(:event).permit(:from,:to,:date,:description, :title, :is_submitted, :event_people)
  end
end  