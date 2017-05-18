class AddColumnCountryCodeToMgAlumni < ActiveRecord::Migration
  def change
    add_column :mg_alumnis, :country_code, :integer
  end
end
