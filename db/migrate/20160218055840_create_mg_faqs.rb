class CreateMgFaqs < ActiveRecord::Migration
  def change
    create_table :mg_faqs do |t|
      t.integer :mg_faq_category_id
      t.integer :mg_faq_sub_category_id
      t.text :question
      t.text :answer

      t.timestamps
    end
  end
end
