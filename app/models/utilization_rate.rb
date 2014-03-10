class UtilizationRate < ActiveRecord::Base
  belongs_to :person
  
  def self.save_utilization_rate(hours,minutes)
    total_minutes = (hours.to_i * 60) + minutes.to_i
    total_hours = 390
    total = (total_minutes.to_i / 390.00) * 100
    total
  end
  
  #class methods
  def self.find_rates(person,*associations,user)
    associations = []
    where = Where.new
    
    if user.is_admin?
      if !person.blank?
        where.and('organizations.name LIKE ?', "%#{user.organization.name}%")
        where.and('utilization_rates.person_id = ?',person)
      else
        where.and('organizations.name LIKE ?', "%#{user.organization.name}%")
      end
    else
      if !person.blank?  
        where.and('departments.name LIKE ?', "%#{user.department.name}%")
        where.and('organizations.name LIKE ?', "%#{user.organization.name}%")
        where.and('utilization_rates.person_id = ?',person) 
      else
        where.and('departments.name LIKE ?', "%#{user.department.name}%") 
        where.and('organizations.name LIKE ?', "%#{user.organization.name}%")     
      end     
    end
   
    #where.and('person_tasks.is_submitted = ? AND (person_tasks.is_approved = ? OR person_tasks.is_disapproved = ?)', "1", "0", "1")
    
    associations << {:person => [:department, :organization] }
    utilization_rates = UtilizationRate.scoped({})
    
    utilization_rates = utilization_rates.all(:include => associations.uniq,:conditions => where.to_s, :order =>'utilization_rates.shift_date DESC, utilization_rates.person_id')  
  end
  
end  