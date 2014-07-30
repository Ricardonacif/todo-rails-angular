json.array!(@tasks) do |task|
  json.extract! task, :id, :body, :public
  json.url task_url(task, format: :json)
end
