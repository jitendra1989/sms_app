class CreateMgCanteenRegularMenus < ActiveRecord::Migration
  def change
    create_table :mg_canteen_regular_menus do |t|
      t.integer :mg_food_item_id
      t.text :description
      t.string :status
      t.text :remark

      t.integer :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.integer :mg_school_id
      t.timestamps
    end
  end
end
