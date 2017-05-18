class AddStatusToMgCanteen < ActiveRecord::Migration
  def change
    add_column :mg_canteens, :status, :string
  end
end
