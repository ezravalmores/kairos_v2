class Search 
  attr_accessor :keywords
  attr_accessor :minimum_date
  attr_accessor :maximum_date
  attr_accessor :limit
  attr_accessor :offset
  attr_accessor :order
  
  
  def cached=(cached)
    @cached = cached
  end
  
  def find_tasks_new(*associtations)
    associations = []
    where = Where.new
     
     unless keywords.blank?
       person_tasks_by_keywords(where)
     end
     
     associations << [:task,:specific_task,{:person => [:department, :organization] }]
     person_tasks = PersonTask.scoped({})
     person_tasks = person_tasks.all(:include => associations.uniq,:conditions => where.to_s, :order => order || 'person_tasks.start DESC, person_tasks.person_id')
     
     pids = person_tasks.map {|p| p.id}
     person_tasks_initial = PersonTask.where(:id => pids).includes(associations.uniq)
     
     if !minimum_date.blank?
       person_tasks = person_tasks_initial.all(:include => associations.uniq, :conditions => ["person_tasks.start >= ?", minimum_date.to_date.beginning_of_day], :order => order || 'person_tasks.start DESC, person_tasks.person_id')  
     end      
     
     if !maximum_date.blank?
       person_tasks = person_tasks_initial.all(:include => associations.uniq, :conditions => ["person_tasks.start <= ?", maximum_date.to_date.end_of_day], :order => order || 'person_tasks.start DESC, person_tasks.person_id')  
     end
     
     if !minimum_date.blank? && !maximum_date.blank?
        person_tasks = person_tasks_initial.all(:include => associations.uniq, :conditions => ["person_tasks.start >= ? AND person_tasks.start <= ?",minimum_date.to_date.beginning_of_day, maximum_date.to_date.end_of_day], :order => order || 'person_tasks.start DESC, person_tasks.person_id')  
     end
     
     person_tasks   
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
       where.or('people.first_name LIKE ?',"%#{keyword}%")
       where.or('departments.name LIKE ?',"%#{keyword}%")
       where.or('organizations.name LIKE ?',"%#{keyword}%") 
       where.or('person_in_charge LIKE ?',"%#{keyword}%")
       where.or('note LIKE ?',"%#{keyword}%")
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