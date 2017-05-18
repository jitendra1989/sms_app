class AddColumnQuantityToMgFoodItem < ActiveRecord::Migration
  def change
    add_column :mg_food_items, :quantity, :integer
  end
end
