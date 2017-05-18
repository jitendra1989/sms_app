class AddTotalMarksToMgDescriptiveIndicator < ActiveRecord::Migration
  def change
    add_column :mg_descriptive_indicators, :total_marks, :float
  end
end
