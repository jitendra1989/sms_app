class AddRoomNoToMgLab < ActiveRecord::Migration
  def change
    add_column :mg_labs, :room_no, :string
  end
end
