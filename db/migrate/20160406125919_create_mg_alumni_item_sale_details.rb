class CreateMgAlumniItemSaleDetails < ActiveRecord::Migration
  def change
    create_table :mg_alumni_item_sale_details do |t|


    	t.integer :mg_inventory_item_id
    	t.float :price
    	t.integer :required_quantity
    	t.integer :mg_user_id
    	t.boolean :cart_status
    	t.string :status
    	
    	  # Audit fields 	
	    t.boolean :is_deleted
	    t.integer :mg_school_id
	    t.integer :created_by
	    t.integer :updated_by

      	t.timestamps
    end
  end
end
