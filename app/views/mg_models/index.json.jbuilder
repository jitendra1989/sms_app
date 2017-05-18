json.array!(@mg_models) do |mg_model|
  json.extract! mg_model, :id, :model_name, :description
  json.url mg_model_url(mg_model, format: :json)
end
