class AddItemCategoryNameToMgFeeCategory < ActiveRecord::Migration
  def change
    add_column :mg_fee_categories, :item_category_name, :string
  end
end
