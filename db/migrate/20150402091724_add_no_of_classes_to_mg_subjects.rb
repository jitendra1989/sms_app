class AddNoOfClassesToMgSubjects < ActiveRecord::Migration
  def change
    add_column :mg_subjects, :no_of_classes, :integer
  end
end
