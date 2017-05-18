class AddIsApplicableToMgGradeComponents < ActiveRecord::Migration
  def change
    add_column :mg_grade_components, :is_applicable, :boolean
  end
end
