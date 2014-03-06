class Search 
  attr_accessor :keywords
  attr_accessor :minimum_date
  attr_accessor :maximum_date
  attr_accessor :person
  attr_accessor :task
  attr_accessor :specific_task
  attr_accessor :department
  attr_accessor :organization
  attr_accessor :from_or_to
  attr_accessor :note
  attr_accessor :limit
  attr_accessor :offset
  attr_accessor :order
  
  def cached=(cached)
    @cached = cached
  end
  
  def find_tasks_new(*associtations)
    associations = []
    pids = []
    where = Where.new
     
    
     unless keywords.blank?
       person_tasks_by_keywords(where)
     end
     
     person_tasks_by_date(where)
     
     unless person.blank?
       where.and("person_tasks.person_id = ?",person)
     end
     
     unless task.blank?
       where.and("person_tasks.task_id = ?",task)
     end
     
     unless specific_task.blank?
       where.and("person_tasks.specific_task_id = ?",specific_task)
     end
     
     unless department.blank?
       where.and("departments.name Like ?","%#{department}%")
     end
     
     unless from_or_to.blank?
       where.and("person_tasks.person_in_charge Like ?","%#{from_or_to}%")
     end
     
     unless note.blank?
       where.and("person_tasks.note Like ?","%#{note}%")
     end
     
     associations << [:task,:specific_task,{:person => [:department, :organization] }]
     person_tasks = PersonTask.scoped({})
     person_tasks.all(:include => associations.uniq,:conditions => where.to_s, :order => order || 'person_tasks.start DESC, person_tasks.person_id')
     
  end
  
  def initialize(params=nil)
     params ||= {}
     params.reject! { |key,value| value.blank? }
     @advanced = false
     @active = false
     @cached = false
     @secured = false

     unless params.empty?
       @keywords           = params[:keywords]         
       @minimum_date       = params[:minimum_date]         
       @maximum_date       = params[:maximum_date] 
       @person             = params[:person]
       @task               = params[:task]
       @specific_task      = params[:specific_task]
       @department         = params[:department]
       @organization       = params[:organization]
       @from_or_to         = params[:from_or_to]
       @note               = params[:note]
       @advanced           = keywords.nil?
       @active = true
     end
   end
  
   def is_active?
     @active
   end
   
   def is_advanced?
     @advanced
   end  

   def is_basic?
     !@advanced
   end
    
   def is_cached?
     @cached
   end
  
  private
  
  def person_tasks_by_keywords(where)
      for keyword in (keywords).split(',')
        keyword.strip!
        next if keyword.blank?
      
        where.or('tasks.name LIKE ?',"%#{keyword}%")
        where.or('specific_tasks.name LIKE ?',"%#{keyword}%")
        where.or('CONCAT(people.first_name,\' \',people.last_name) LIKE ?',"%#{keyword}%")
        where.or('departments.name LIKE ?',"%#{keyword}%")
        where.or('organizations.name LIKE ?',"%#{keyword}%") 
        where.or('person_in_charge LIKE ?',"%#{keyword}%")
        where.or('note LIKE ?',"%#{keyword}%")
      end
     where
  end
  
  def person_tasks_by_date(where)
     if !minimum_date.blank? && maximum_date.blank?
       where.and("person_tasks.start >= ?", minimum_date.to_date.beginning_of_day)  
     end      
     
     if !maximum_date.blank? && minimum_date.blank?
       where.and("person_tasks.start <= ?", maximum_date.to_date.end_of_day)
     end
     
     if !minimum_date.blank? && !maximum_date.blank?
       where.and("person_tasks.start >= ? AND person_tasks.start <= ?",minimum_date.to_date.beginning_of_day, maximum_date.to_date.end_of_day)
     end
     where
  end

  
  
  def fix_date(date)
    date = Date.parse(date)
    if date.year < 1753 || date.year > 9998
      return nil
    end
    return date.to_s(:db)
  end
end  