class CreateMgResourceTypes < ActiveRecord::Migration
  def change
    create_table :mg_resource_types do |t|
      t.string :name
      t.text :description
      t.integer :mg_resource_category_id
      t.integer :max_issuable_count
      t.integer :max_borrow_day
      t.integer :renewal_period
      t.integer :max_renewals_allowed
      t.string :prefix
      t.boolean :is_deleted
      t.integer :mg_school_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
