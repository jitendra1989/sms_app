class AddAssessmentToMgFaGroup < ActiveRecord::Migration
  def change
    add_column :mg_fa_groups, :assessment, :string
  end
end
