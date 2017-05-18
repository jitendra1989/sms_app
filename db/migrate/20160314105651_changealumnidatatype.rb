class Changealumnidatatype < ActiveRecord::Migration
  def change
  	 change_table :mg_alumnis do |t|
     
      t.change :is_name_sharable, :boolean
      t.change :is_email_id_sharable, :boolean
      t.change :is_mobile_no_sharable, :boolean
  end
  end
end
