json.array!(@mg_permissions) do |mg_permission|
  json.extract! mg_permission, :id, :mg_model_id, :mg_action_id
  json.url mg_permission_url(mg_permission, format: :json)
end
