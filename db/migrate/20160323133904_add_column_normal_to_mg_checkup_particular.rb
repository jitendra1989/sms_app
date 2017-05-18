class AddColumnNormalToMgCheckupParticular < ActiveRecord::Migration
  def change
    add_column :mg_checkup_particulars, :normal, :string
  end
end
