class AddExamMgFeeCategoryIdToMgSchool < ActiveRecord::Migration
  def change
    add_column :mg_schools, :exam_mg_fee_category_id, :integer
  end
end
