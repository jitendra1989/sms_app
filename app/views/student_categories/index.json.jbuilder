json.array!(@mg_student_categories) do |mg_student_category|
  json.extract! mg_student_category, :id, :name
  json.url mg_student_category_url(mg_student_category, format: :json)
end
