class AddColumnStatusToMgImage < ActiveRecord::Migration
  def change
    add_column :mg_images, :status, :string
  end
end
