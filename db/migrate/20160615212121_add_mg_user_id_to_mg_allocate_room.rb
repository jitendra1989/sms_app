class AddMgUserIdToMgAllocateRoom < ActiveRecord::Migration
  def change
    add_column :mg_allocate_rooms, :mg_user_id, :integer
  end
end
