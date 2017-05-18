class ChangeStringToTextInMgFaGroups < ActiveRecord::Migration
  def change
    change_column :mg_fa_groups, :description, :text
  end
end
