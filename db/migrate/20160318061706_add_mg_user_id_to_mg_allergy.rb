class AddMgUserIdToMgAllergy < ActiveRecord::Migration
  def change
    add_column :mg_allergies, :mg_user_id, :integer
  end
end
