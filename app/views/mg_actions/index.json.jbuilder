json.array!(@mg_actions) do |mg_action|
  json.extract! mg_action, :id, :action_name, :description
  json.url mg_action_url(mg_action, format: :json)
end
