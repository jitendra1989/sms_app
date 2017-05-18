class AddUnitBrandToMgFoodItem < ActiveRecord::Migration
  def change
    add_column :mg_food_items, :unit, :string
    add_column :mg_food_items, :brand, :string
  end
end
