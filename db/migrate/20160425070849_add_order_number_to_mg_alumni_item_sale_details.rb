class AddOrderNumberToMgAlumniItemSaleDetails < ActiveRecord::Migration
  def change
    add_column :mg_alumni_item_sale_details, :order_number, :string
  end
end
