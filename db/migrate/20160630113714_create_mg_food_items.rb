class CreateMgFoodItems < ActiveRecord::Migration
  def change
    create_table :mg_food_items do |t|

      t.string :item_name
      t.integer :price
      t.string :category
      t.text :description

      t.integer :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.integer :mg_school_id

      t.timestamps
    end
  end
end
