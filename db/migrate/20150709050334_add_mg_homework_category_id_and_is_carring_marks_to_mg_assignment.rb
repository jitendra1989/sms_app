class AddMgHomeworkCategoryIdAndIsCarringMarksToMgAssignment < ActiveRecord::Migration
  def change
    add_column :mg_assignments, :mg_homework_category_id, :integer
    add_column :mg_assignments, :is_carring_marks, :boolean
  end
end
