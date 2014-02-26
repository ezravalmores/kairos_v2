class Right < ActiveRecord::Base
  belongs_to :role
  
  # Validations  
  validates_presence_of :action, :context
  
  # Named scopes
  
  # Callback methods

  # Class methods
  
  # Instance methods
  def has?(action,context)
    get_action_regex =~ action && get_context_regex =~ context
  end

  
  private
    def get_action_regex
      @action_regex ||= Regexp.new(action)
    end
    
    def get_context_regex
      @context_regex ||= Regexp.new(context)
    end
end  