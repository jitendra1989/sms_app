class CreateMgFeeFines < ActiveRecord::Migration
  def change
    create_table :mg_fee_fines do |t|
    	 t.string :fine_name
      t.string :fine_description

      #Audit fields
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
