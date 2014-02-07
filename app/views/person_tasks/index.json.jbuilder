json.array!(@person_times) do |person_time|
  json.extract! person_time, :id
  json.url person_time_url(person_time, format: :json)
end
