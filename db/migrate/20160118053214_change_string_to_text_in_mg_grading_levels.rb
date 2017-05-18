class ChangeStringToTextInMgGradingLevels < ActiveRecord::Migration
  def change
    change_column :mg_grading_levels, :description, :text
  end
end
