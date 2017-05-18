class ChangeStringToTextInMgDescriptiveIndicators < ActiveRecord::Migration
  def change
    change_column :mg_descriptive_indicators, :description, :text
  end
end
