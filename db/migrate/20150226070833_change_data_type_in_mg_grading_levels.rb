class ChangeDataTypeInMgGradingLevels < ActiveRecord::Migration
  def change
  	change_column :mg_grading_levels, :min_score, :float
  	change_column :mg_grading_levels, :credit_points, :float
  end
end
