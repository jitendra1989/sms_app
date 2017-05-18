class AddSubjectToMgDisciplinaryAction < ActiveRecord::Migration
  def change
    add_column :mg_disciplinary_actions, :subject, :string
  end
end
