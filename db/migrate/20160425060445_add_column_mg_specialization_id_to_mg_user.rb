class AddColumnMgSpecializationIdToMgUser < ActiveRecord::Migration
  def change
    add_column :mg_users, :mg_specialization_id, :integer
  end
end
