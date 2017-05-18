class AddColumnIsDobSearchableToMgAlumni < ActiveRecord::Migration
  def change
    add_column :mg_alumnis, :is_date_of_birth_searchable, :boolean
  end
end
