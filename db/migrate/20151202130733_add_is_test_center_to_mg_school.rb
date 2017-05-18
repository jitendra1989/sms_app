class AddIsTestCenterToMgSchool < ActiveRecord::Migration
  def change
    add_column :mg_schools, :is_test_center, :boolean
    add_column :mg_schools, :disable_entrance_exam_test, :boolean
  end
end
