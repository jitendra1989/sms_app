class ChangeStringToTextInMgObservationGroups < ActiveRecord::Migration
  def change
    change_column :mg_observation_groups, :description, :text
  end
end
