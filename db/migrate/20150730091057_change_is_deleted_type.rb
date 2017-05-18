class ChangeIsDeletedType < ActiveRecord::Migration
  def change
   change_column :mg_entrance_exam_details, :is_deleted, :boolean
  end  
end
