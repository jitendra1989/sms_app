class CreateMgLibrarySettings < ActiveRecord::Migration
  def change
    create_table :mg_library_settings do |t|
      t.integer :max_books_issuable
      t.integer :max_borrow_days
      t.float :fine_for_late_return
      t.integer :max_days_on_reservation_after_return
      t.integer :mg_school_id
      t.boolean :is_deleted
      t.integer :created_by
      t.integer :updated_by
      t.integer :mg_fee_category_id
      t.timestamps
    end
  end
end
