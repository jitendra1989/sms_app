class Changecolumninexamination < ActiveRecord::Migration
  def change
  	rename_column :mg_assessment_scores,:grade_points,:marks_obtained
  end
end
