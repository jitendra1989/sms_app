class AddPayScaleToMgEmployees < ActiveRecord::Migration
  def change
    	add_column :mg_employees, :pay_scale, :decimal, :precision => 8, :scale => 2
     	add_column :mg_employees, :last_working_day, :date
  end
end
