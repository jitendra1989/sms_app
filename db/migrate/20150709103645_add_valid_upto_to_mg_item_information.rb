class AddValidUptoToMgItemInformation < ActiveRecord::Migration
  def change
    add_column :mg_item_informations, :valid_upto, :date
  end
end
