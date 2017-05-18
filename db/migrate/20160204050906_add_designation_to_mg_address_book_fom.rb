class AddDesignationToMgAddressBookFom < ActiveRecord::Migration
  def change
    add_column :mg_address_book_foms, :designation, :string
  end
end
