class AddCollectionTypeToMgFeeCollection < ActiveRecord::Migration
  def change
    add_column :mg_fee_collections, :collection_type, :string
  end
end
