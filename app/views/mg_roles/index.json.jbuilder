json.array!(@mg_roles) do |mg_role|
  json.extract! mg_role, :id, :role_name, :description
  json.url mg_role_url(mg_role, format: :json)
end
