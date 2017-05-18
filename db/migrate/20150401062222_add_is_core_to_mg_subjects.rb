class AddIsCoreToMgSubjects < ActiveRecord::Migration
  def change
    add_column :mg_subjects, :is_core, :boolean
  end
end
