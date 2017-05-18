json.array!(@mg_user_roles) do |mg_user_role|
  json.extract! mg_user_role, :id, :mg_user_id, :mg_role_id
  json.url mg_user_role_url(mg_user_role, format: :json)
end
