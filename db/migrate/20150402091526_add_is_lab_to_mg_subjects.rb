class AddIsLabToMgSubjects < ActiveRecord::Migration
  def change
    add_column :mg_subjects, :is_lab, :boolean
  end
end
