class AddSubdomainToMgSchools < ActiveRecord::Migration
  def change
    add_column :mg_schools, :subdomain, :string
  end
end
