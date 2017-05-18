class AddMgWingIdToMgAlumniGetTogether < ActiveRecord::Migration
  def change
    add_column :mg_alumni_get_togethers, :mg_wing_id, :integer
    add_column :mg_alumni_get_togethers, :passout_year, :string
    add_column :mg_alumni_get_togethers, :mg_employee_specialization_id, :integer

  end
end
