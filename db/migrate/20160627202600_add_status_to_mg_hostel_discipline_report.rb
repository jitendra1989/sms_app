class AddStatusToMgHostelDisciplineReport < ActiveRecord::Migration
  def change
    add_column :mg_hostel_discipline_reports, :status, :string
  end
end
