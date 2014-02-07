module PersonTimesHelper
  
  def compute_utilization_rate(productive_hours,productive_minutes)
    total_minutes = (productive_hours.to_i * 60) + productive_minutes.to_i
    total_hours = 390
    total = number_with_precision((total_minutes.to_i / 390.00) * 100, :precision => 2)
    total
  end
end
