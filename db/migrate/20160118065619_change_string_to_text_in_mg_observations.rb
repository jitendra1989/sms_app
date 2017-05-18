class ChangeStringToTextInMgObservations < ActiveRecord::Migration
  def change
    change_column :mg_observations, :description, :text
  end
end
