class RenameColumnResultToMgHealthTest < ActiveRecord::Migration
  def change
    rename_column :mg_health_tests, :normal, :result
  end
end
