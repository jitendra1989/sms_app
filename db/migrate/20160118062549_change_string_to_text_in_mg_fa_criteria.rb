class ChangeStringToTextInMgFaCriteria < ActiveRecord::Migration
  def change
    change_column :mg_fa_criteria, :description, :text
  end
end
