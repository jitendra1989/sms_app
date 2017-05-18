class CreateMgEmployeeCategories < ActiveRecord::Migration
  def change
    create_table :mg_employee_categories do |t|

 	  t.string :category_name
      t.string :prefix
      t.string :suffix
      t.boolean :status
      t.string :position
      

      #Audit fields
        t.boolean :is_deleted
        t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end
