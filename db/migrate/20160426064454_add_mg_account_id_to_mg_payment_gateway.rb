class AddMgAccountIdToMgPaymentGateway < ActiveRecord::Migration
  def change
  	add_column :mg_payment_gateways, :mg_account_id, :integer
  	add_column :mg_payment_gateways, :is_to_central, :boolean
  end
end
