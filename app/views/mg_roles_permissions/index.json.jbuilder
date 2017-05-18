json.array!(@mg_roles_permissions) do |mg_roles_permission|
  json.extract! mg_roles_permission, :id, :mg_role_id, :mg_permission_id
  json.url mg_roles_permission_url(mg_roles_permission, format: :json)
end
