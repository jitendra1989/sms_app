class ChangeStringToTextInMgCceExamCategories < ActiveRecord::Migration
  def change
    change_column :mg_cce_exam_categories, :description, :text
  end
end
