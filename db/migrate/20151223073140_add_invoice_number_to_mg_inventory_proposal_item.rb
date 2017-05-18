class AddInvoiceNumberToMgInventoryProposalItem < ActiveRecord::Migration
  def change
    add_column :mg_inventory_proposal_items, :invoice_number, :string
  end
end
