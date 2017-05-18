# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 201412181211133) do

  create_table "add_guests", force: true do |t|
    t.string   "guest_name"
    t.string   "guest_details"
    t.integer  "mobile_no"
    t.string   "email_id"
    t.string   "status"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "document_managements", force: true do |t|
    t.string   "name"
    t.string   "document_type"
    t.string   "access_type"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "mg_user_id"
    t.boolean  "is_transfer_certificate_produced"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fullcalendar_engine_event_series", force: true do |t|
    t.integer  "frequency",    default: 1
    t.string   "period",       default: "monthly"
    t.datetime "starttime"
    t.datetime "endtime"
    t.boolean  "all_day",      default: false
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fullcalendar_engine_events", force: true do |t|
    t.string   "title"
    t.datetime "starttime"
    t.datetime "endtime"
    t.boolean  "all_day",         default: false
    t.text     "description"
    t.integer  "event_series_id"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fullcalendar_engine_events", ["event_series_id"], name: "index_fullcalendar_engine_events_on_event_series_id", using: :btree

  create_table "inventory_stack_managements", force: true do |t|
    t.string   "room_no"
    t.string   "rack_no"
    t.string   "prefix"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_inventory_store_management_id"
    t.integer  "mg_inventory_room_management_id"
  end

  create_table "legacy_session_table", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "legacy_session_table", ["session_id"], name: "index_legacy_session_table_on_session_id", unique: true, using: :btree
  add_index "legacy_session_table", ["updated_at"], name: "index_legacy_session_table_on_updated_at", using: :btree

  create_table "mg_account_central_incharges", force: true do |t|
    t.integer  "mg_employee_department_id"
    t.integer  "mg_employee_id"
    t.integer  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_user_id"
  end

  create_table "mg_account_transactions", force: true do |t|
    t.integer  "mg_to_account_id"
    t.integer  "mg_from_account_id"
    t.date     "current_date"
    t.string   "for_module"
    t.integer  "mg_particular_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount"
    t.string   "amount_transfer_type"
  end

  create_table "mg_accounts", force: true do |t|
    t.string   "mg_account_name"
    t.integer  "mg_department_id"
    t.integer  "mg_employee_id"
    t.text     "description"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_user_id"
  end

  create_table "mg_action_requireds", force: true do |t|
    t.text     "action_required"
    t.text     "description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_actions", force: true do |t|
    t.string   "action_name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_add_reports", force: true do |t|
    t.integer  "mg_vehicle_id"
    t.integer  "mg_report_type_id"
    t.integer  "entered_by"
    t.date     "valid_from"
    t.date     "valid_to"
    t.text     "comments"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "vendor_name"
    t.float    "amount",             limit: 24
    t.date     "payment_date"
    t.integer  "mg_payment_type_id"
    t.boolean  "is_payment_made"
  end

  create_table "mg_address_book_foms", force: true do |t|
    t.string   "name"
    t.text     "Address"
    t.string   "contact_number"
    t.integer  "mg_designation_fom_id"
    t.string   "email_id"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "designation"
  end

  create_table "mg_address_files", force: true do |t|
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "address_type"
    t.string   "street"
    t.string   "land_mark"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "pin_code"
    t.string   "country_code"
    t.boolean  "notification"
    t.boolean  "subscription"
    t.integer  "mg_user_file_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_addresses", force: true do |t|
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "address_type"
    t.string   "street"
    t.string   "landmark"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "pin_code"
    t.integer  "country_code"
    t.integer  "mg_user_id"
    t.boolean  "notification"
    t.boolean  "subscription"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_admission_result_texts", force: true do |t|
    t.text     "result_header"
    t.text     "result_footer"
    t.string   "start_date"
    t.string   "end_date"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_admission_results", force: true do |t|
    t.integer  "mg_course_id"
    t.integer  "mg_batch_id"
    t.string   "student_name"
    t.string   "parent_name"
    t.string   "mobile_number"
    t.string   "email_id"
    t.string   "status"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_album_photos", force: true do |t|
    t.integer  "mg_album_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_albums", force: true do |t|
    t.string   "name"
    t.integer  "mg_event_id"
    t.text     "description"
    t.integer  "mg_employee_department_id"
    t.integer  "mg_batch_id"
    t.boolean  "accessable_to­_employees"
    t.boolean  "accessable_to­_students"
    t.boolean  "accessable_to­_guardians"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accessable_teacher"
  end

  create_table "mg_allergies", force: true do |t|
    t.integer  "mg_batch_id"
    t.integer  "mg_student_id"
    t.integer  "mg_employee_department_id"
    t.integer  "mg_employee_id"
    t.string   "name"
    t.text     "description"
    t.string   "status"
    t.text     "medication_detail"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "allergy_for"
    t.integer  "mg_user_id"
  end

  create_table "mg_allocate_room_lists", force: true do |t|
    t.integer  "mg_allocate_room_id"
    t.integer  "mg_student_id"
    t.string   "admission_number"
    t.integer  "mg_hostel_floor_id"
    t.integer  "mg_hostel_room_type_id"
    t.integer  "mg_hostel_room_id"
    t.boolean  "is_allocated"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_allocate_rooms", force: true do |t|
    t.integer  "mg_hostel_details_id"
    t.integer  "mg_wing_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_user_id"
  end

  create_table "mg_alumni_get_togethers", force: true do |t|
    t.string   "event_name"
    t.date     "event_date"
    t.time     "start_time"
    t.time     "end_time"
    t.text     "venue"
    t.string   "status"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_wing_id"
    t.string   "passout_year"
    t.integer  "mg_employee_specialization_id"
    t.integer  "mg_user_id"
  end

  create_table "mg_alumni_item_sale_details", force: true do |t|
    t.integer  "mg_inventory_item_id"
    t.float    "price",                limit: 24
    t.integer  "required_quantity"
    t.integer  "mg_user_id"
    t.boolean  "cart_status"
    t.string   "status"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "order_number"
  end

  create_table "mg_alumni_job_posting_details", force: true do |t|
    t.string   "position"
    t.text     "job_description"
    t.string   "minimum_qualification"
    t.integer  "minimum_experience_required"
    t.text     "company"
    t.string   "company_website"
    t.integer  "relevant_experience"
    t.string   "alumni_id"
    t.string   "referral_code"
    t.string   "functional_area"
    t.string   "technical_skills"
    t.string   "soft_skills"
    t.string   "salary"
    t.date     "interview_date"
    t.date     "last_date_of_application"
    t.string   "status"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_alumni_photo_galleries", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "mg_alumni_id"
    t.integer  "mg_user_id"
    t.string   "status"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_alumni_pollings", force: true do |t|
    t.text     "question"
    t.text     "description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_alumni_programme_attendeds", force: true do |t|
    t.integer  "mg_wing_id"
    t.string   "time_table_year"
    t.integer  "mg_employee_specialization_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_alumni_id"
  end

  create_table "mg_alumnis", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.date     "date_of_birth"
    t.string   "gender"
    t.integer  "phone_number",                        limit: 8
    t.integer  "integer",                             limit: 8
    t.integer  "mobile_number",                       limit: 8
    t.string   "email_id"
    t.text     "current_location"
    t.text     "current_address"
    t.string   "current_profession"
    t.string   "designation"
    t.string   "current_organization"
    t.text     "hobbies"
    t.string   "user_name"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "mg_school_id"
    t.integer  "mg_user_id"
    t.string   "status"
    t.boolean  "is_name_sharable"
    t.boolean  "is_email_id_sharable"
    t.boolean  "is_mobile_no_sharable"
    t.string   "admission_number"
    t.boolean  "is_programme_searchable"
    t.boolean  "is_passing_out_searchable"
    t.boolean  "is_specialization_searchable"
    t.boolean  "is_current_location_searchable"
    t.boolean  "is_current_profession_searchable"
    t.boolean  "is_current_designation_searchable"
    t.boolean  "is_current_organization_searchabler"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "country_code"
    t.boolean  "is_date_of_birth_searchable"
  end

  create_table "mg_assessment_scores", force: true do |t|
    t.integer  "mg_student_id"
    t.float    "marks_obtained",              limit: 24
    t.integer  "mg_exam_id"
    t.integer  "mg_batch_id"
    t.integer  "mg_descriptive_indicator_id"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_assignment_documentations", force: true do |t|
    t.integer  "mg_student_id"
    t.integer  "mg_assignment_id"
    t.integer  "mg_employee_id"
    t.string   "user_type"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_assignment_submissions", force: true do |t|
    t.integer  "mg_student_id"
    t.integer  "mg_assignment_id"
    t.string   "status"
    t.text     "remarks"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_assignments", force: true do |t|
    t.integer  "mg_employee_id"
    t.integer  "mg_subject_id"
    t.integer  "mg_batch_id"
    t.string   "title"
    t.text     "detail"
    t.date     "due_date"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_homework_category_id"
    t.boolean  "is_carring_marks"
  end

  create_table "mg_attendances", force: true do |t|
    t.integer  "mg_student_id"
    t.integer  "mg_period_table_entry_id"
    t.boolean  "forenoon"
    t.boolean  "afternoon"
    t.string   "reason"
    t.date     "attendance_date"
    t.integer  "mg_batch_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_bank_account_details", force: true do |t|
    t.string   "bank_name"
    t.text     "branch_address"
    t.string   "account_number"
    t.string   "ifs_code"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_employee_id"
    t.string   "ac_holder_name"
  end

  create_table "mg_batch_contents", force: true do |t|
    t.integer  "mg_batch_id"
    t.integer  "mg_my_question_id"
    t.integer  "mg_employee_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_batch_documents", force: true do |t|
    t.integer  "mg_employee_id"
    t.integer  "mg_batch_id"
    t.integer  "mg_document_management_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_batch_groups", force: true do |t|
    t.integer  "mg_course_id"
    t.string   "name"
    t.integer  "mg_school_id"
    t.string   "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_batch_subjects", force: true do |t|
    t.integer  "mg_batch_id"
    t.integer  "mg_subject_id"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_batch_syllabuses", force: true do |t|
    t.integer  "mg_syllabus_id"
    t.integer  "mg_batch_id"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mg_batch_syllabuses", ["mg_batch_id"], name: "index_mg_batch_syllabuses_on_mg_batch_id", using: :btree

  create_table "mg_batches", force: true do |t|
    t.string   "name"
    t.integer  "mg_course_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "is_active"
    t.integer  "mg_employee_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "class_strength"
  end

  create_table "mg_bed_assignments", force: true do |t|
    t.integer  "mg_bed_details_id"
    t.date     "admitted_date"
    t.time     "admitted_time"
    t.date     "discharge_date"
    t.time     "discharge_time"
    t.string   "user_id"
    t.string   "status"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_doctor_id"
    t.text     "comments"
    t.string   "module_type"
  end

  create_table "mg_bed_details", force: true do |t|
    t.string   "bed_no"
    t.text     "description"
    t.string   "status"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "module_type"
  end

  create_table "mg_book_purchase_details", force: true do |t|
    t.string   "book_name"
    t.string   "author"
    t.string   "publisher"
    t.float    "cost",                limit: 24
    t.integer  "no_of_copies"
    t.float    "total",               limit: 24
    t.integer  "mg_course_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_book_purchase_id"
  end

  create_table "mg_book_purchases", force: true do |t|
    t.string   "vendor_name"
    t.date     "date_of_purchase"
    t.float    "Amount_paid",      limit: 24
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_books_categories", force: true do |t|
    t.string   "category_name"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_books_inventories", force: true do |t|
    t.string   "book_no"
    t.string   "book_name"
    t.string   "author"
    t.string   "publisher"
    t.string   "edition"
    t.float    "cost",                    limit: 24
    t.integer  "mg_books_category_id"
    t.integer  "mg_course_id"
    t.boolean  "non_issuable"
    t.boolean  "is_damaged"
    t.boolean  "is_lost"
    t.string   "status"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.string   "issued_to"
    t.date     "due_date"
    t.integer  "reserved_by"
    t.date     "reservation_due_date"
    t.integer  "mg_books_transaction_id"
    t.date     "issued_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_books_transactions", force: true do |t|
    t.integer  "mg_student_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "issued_by"
    t.integer  "received_by"
    t.string   "return_book_condition"
    t.integer  "mg_books_inventory_id"
    t.string   "status"
    t.date     "due_date"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_resource_inventory_id"
    t.string   "user_type"
    t.integer  "mg_employee_id"
    t.boolean  "is_there_a_delay"
    t.boolean  "is_it_returned_as_was_taken"
    t.string   "is_fine_applicable"
    t.integer  "no_of_days_delayed"
    t.float    "amount",                      limit: 24
  end

  create_table "mg_booster_dose_details", force: true do |t|
    t.integer  "mg_booster_dose_id"
    t.integer  "mg_student_id"
    t.integer  "mg_batch_id"
    t.integer  "mg_time_table_id"
    t.date     "date"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "frequency"
    t.boolean  "is_particular_student"
    t.date     "due_date"
  end

  create_table "mg_booster_doses", force: true do |t|
    t.string   "name"
    t.string   "frequency"
    t.text     "description"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_call_purposes", force: true do |t|
    t.string   "purpose_name"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_call_records", force: true do |t|
    t.string   "purpose_name"
    t.string   "name"
    t.string   "phone_number"
    t.string   "alternate_number"
    t.string   "email_id"
    t.integer  "mg_employee_id"
    t.string   "status"
    t.text     "details"
    t.text     "action_performed"
    t.integer  "received_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_caller_categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_caller_category_foms", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_canteen_amount_transactions", force: true do |t|
    t.boolean  "is_central"
    t.boolean  "is_account"
    t.integer  "amount"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_canteen_balance_amounts", force: true do |t|
    t.integer  "mg_canteen_bill_detail_id"
    t.integer  "paid_amount"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_canteen_bill_details", force: true do |t|
    t.string   "user_type"
    t.integer  "mg_student_id"
    t.string   "student_admission_no"
    t.integer  "mg_batch_id"
    t.integer  "mg_employee_id"
    t.string   "employee_no"
    t.integer  "mg_employee_department_id"
    t.integer  "total_amount"
    t.integer  "paid_amount"
    t.integer  "balance_amount"
    t.integer  "mg_user_id"
    t.integer  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_canteen_bill_payments", force: true do |t|
    t.integer  "mg_canteen_bill_detail_id"
    t.integer  "mg_food_item_id"
    t.integer  "quantity"
    t.integer  "amount"
    t.integer  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit_quantity"
  end

  create_table "mg_canteen_meals", force: true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "mg_day_id"
    t.integer  "mg_meal_category_id"
    t.integer  "mg_food_item_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_canteen_id"
  end

  create_table "mg_canteen_regular_menus", force: true do |t|
    t.integer  "mg_food_item_id"
    t.text     "description"
    t.string   "status"
    t.text     "remark"
    t.integer  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_canteen_wallet_amounts", force: true do |t|
    t.string   "user_type"
    t.integer  "mg_student_id"
    t.integer  "mg_batch_id"
    t.integer  "mg_employee_id"
    t.integer  "mg_employee_department_id"
    t.integer  "wallet_amount"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_canteens", force: true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "mg_category_tables", force: true do |t|
    t.integer  "mg_lab_id"
    t.string   "category_name"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_cce_exam_categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "updated_by"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_cce_grades", force: true do |t|
    t.string   "name"
    t.float    "grade_point",          limit: 24
    t.integer  "mg_cce_grades_set_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_cce_grades_sets", force: true do |t|
    t.string   "name"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_cce_reports", force: true do |t|
    t.integer  "mg_student_id"
    t.integer  "mg_batch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_cce_weightages", force: true do |t|
    t.string   "weightages"
    t.string   "criteria_type"
    t.integer  "mg_cce_exam_category_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_cce_weightages_courses", force: true do |t|
    t.integer  "mg_cce_weightages_id"
    t.integer  "mg_course_id"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_central_account_transactions", force: true do |t|
    t.integer  "mg_to_account_id"
    t.integer  "mg_from_account_id"
    t.date     "current_date"
    t.string   "for_module"
    t.integer  "mg_particular_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "amount"
    t.string   "transaction_type"
    t.string   "amount_transfer_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "purpose"
    t.string   "status"
    t.text     "Reason"
  end

  create_table "mg_change_teachers", force: true do |t|
    t.integer  "mg_employee_id"
    t.integer  "mg_time_table_entry_id"
    t.date     "date"
    t.integer  "mg_subject_id"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_check_up_schedule_records", force: true do |t|
    t.integer  "mg_check_up_schedule_id"
    t.integer  "mg_employee_department_id"
    t.integer  "mg_batch_id"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_check_up_type_id"
  end

  create_table "mg_check_up_schedules", force: true do |t|
    t.string   "doctor_name"
    t.integer  "mg_check_up_type_id"
    t.date     "date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "checkup_for"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_doctor_id"
  end

  create_table "mg_checkup_particulars", force: true do |t|
    t.string   "particulars"
    t.string   "applicable"
    t.boolean  "show_in_healthcard"
    t.string   "mg_checkup_type_id"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "normal"
  end

  create_table "mg_checkup_types", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_class_designations", force: true do |t|
    t.string   "name"
    t.float    "marks",        limit: 24
    t.integer  "mg_course_id"
    t.float    "cgpa",         limit: 24
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_class_timings", force: true do |t|
    t.integer  "mg_batch_id"
    t.integer  "mg_weekday_id"
    t.integer  "mg_wing_id"
    t.string   "name"
    t.time     "start_time"
    t.time     "end_time"
    t.boolean  "is_break"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_committee_members", force: true do |t|
    t.integer  "mg_event_committee_id"
    t.integer  "mg_employee_id"
    t.integer  "mg_student_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_common_custom_fields", force: true do |t|
    t.string   "model_name"
    t.string   "name"
    t.string   "text_data"
    t.string   "data_type"
    t.string   "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_complain_hostels", force: true do |t|
    t.integer  "mg_hostel_details_id"
    t.string   "room_no"
    t.text     "reason"
    t.string   "programme"
    t.date     "date"
    t.string   "status"
    t.integer  "mg_student_id"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_course_observation_groups", force: true do |t|
    t.integer  "mg_observation_group_id"
    t.integer  "mg_course_id"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_courses", force: true do |t|
    t.string   "course_name"
    t.string   "code"
    t.string   "section_name"
    t.string   "grading_type"
    t.integer  "mg_wing_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_curriculum_courses", force: true do |t|
    t.string   "course_name"
    t.text     "description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_curriculum_grades", force: true do |t|
    t.string   "grade_name"
    t.text     "description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_curriculums", force: true do |t|
    t.integer  "mg_user_id"
    t.integer  "mg_subject_id"
    t.integer  "mg_topic_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_custom_fields_data", force: true do |t|
    t.string   "mg_user_id"
    t.string   "mg_custom_field_id"
    t.string   "value"
    t.string   "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_descriptive_indicators", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "mg_fa_criteria_id"
    t.string   "describable_type"
    t.integer  "describable_id"
    t.integer  "sort_order"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "total_marks",       limit: 24
  end

  create_table "mg_designation_foms", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_disciplinary_action_students", force: true do |t|
    t.integer  "mg_disciplinary_action_id"
    t.integer  "mg_student_id"
    t.integer  "mg_batch_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_disciplinary_actions", force: true do |t|
    t.integer  "mg_wing_id"
    t.integer  "mg_batches_id"
    t.integer  "mg_student_id"
    t.text     "remark"
    t.text     "action_taken"
    t.string   "status"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
  end

  create_table "mg_document_managements", force: true do |t|
    t.string   "name"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "mg_user_id"
    t.integer  "mg_employee_folder_id"
    t.integer  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_type"
    t.string   "access_type"
    t.integer  "mg_batch_id"
    t.integer  "mg_event_id"
    t.integer  "mg_add_report_id"
    t.integer  "mg_alumni_programme_attended_id"
    t.integer  "mg_inventory_item_id"
  end

  create_table "mg_email_files", force: true do |t|
    t.string   "email_id"
    t.string   "email_type"
    t.boolean  "notification"
    t.boolean  "subscription"
    t.integer  "mg_user_file_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_emails", force: true do |t|
    t.string   "mg_email_id"
    t.string   "email_type"
    t.boolean  "notification"
    t.boolean  "subscription"
    t.integer  "mg_user_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_employee_attendances", force: true do |t|
    t.date     "absent_date"
    t.integer  "mg_employee_id"
    t.integer  "mg_leave_type_id"
    t.integer  "is_approved"
    t.boolean  "is_lock"
    t.string   "reason"
    t.string   "time"
    t.boolean  "is_halfday"
    t.boolean  "is_late_come"
    t.boolean  "is_afternoon"
    t.boolean  "abcent_without_notice"
    t.integer  "mg_employee_department_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_employee_leave_application_id"
  end

  create_table "mg_employee_biometric_attendances", force: true do |t|
    t.date     "date"
    t.time     "check_in"
    t.time     "check_out"
    t.integer  "mg_employee_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_employee_categories", force: true do |t|
    t.string   "category_name"
    t.string   "prefix"
    t.string   "suffix"
    t.boolean  "status"
    t.string   "position"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_employee_category_id"
  end

  create_table "mg_employee_children", force: true do |t|
    t.integer  "mg_user_id"
    t.string   "employee_name"
    t.string   "employee_type"
    t.string   "employee_id"
    t.date     "joining_date"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_employee_departments", force: true do |t|
    t.string   "department_name"
    t.string   "department_code"
    t.boolean  "status"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_employee_files", force: true do |t|
    t.integer  "mg_user_file_id"
    t.string   "emergency_contact_name"
    t.string   "emergency_contact_number"
    t.string   "language"
    t.string   "nationality"
    t.string   "employee_number"
    t.string   "joining_date"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "job_title"
    t.string   "qualification"
    t.integer  "experience_year"
    t.integer  "experience_month"
    t.date     "date_of_birth"
    t.string   "marital_status"
    t.string   "father_name"
    t.string   "mother_name"
    t.string   "blood_group"
    t.string   "referred_by"
    t.string   "designation"
    t.string   "max_no_of_class"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_employee_folders", force: true do |t|
    t.string   "folder_name"
    t.integer  "mg_employee_id"
    t.integer  "mg_employee_chaild_folder_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_employee_grade_components", force: true do |t|
    t.integer  "mg_employee_id"
    t.integer  "mg_salary_component_id"
    t.float    "amount",                 limit: 24
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_edited"
  end

  create_table "mg_employee_grades", force: true do |t|
    t.string   "grade_name"
    t.string   "priority"
    t.boolean  "status"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_employee_leave_applications", force: true do |t|
    t.integer  "mg_employee_id"
    t.integer  "mg_employee_leave_type_id"
    t.date     "from_date"
    t.date     "to_date"
    t.string   "reject_reason"
    t.string   "reason"
    t.string   "status"
    t.boolean  "is_halfday"
    t.boolean  "is_afternoon"
    t.date     "status_date"
    t.date     "applied_date"
    t.integer  "mg_employee_leave_application_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_employee_leave_types", force: true do |t|
    t.string   "leave_name"
    t.string   "leave_code"
    t.float    "max_leave_count",                 limit: 24
    t.integer  "reset_period"
    t.date     "reset_date"
    t.boolean  "is_auto_reset"
    t.boolean  "is_carry_forward"
    t.boolean  "status"
    t.string   "carry_forward_limit"
    t.float    "accumilation_count",              limit: 24
    t.string   "accumilation_period"
    t.string   "min_leave_count"
    t.integer  "mg_employee_type_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_accumilation"
    t.integer  "minimum_year_experience"
    t.integer  "minimum_month_experience"
    t.string   "gender"
    t.boolean  "is_leave_should_not_be_deducted"
    t.string   "marital_status"
    t.boolean  "is_showable"
  end

  create_table "mg_employee_leaves", force: true do |t|
    t.integer  "mg_employee_id"
    t.integer  "mg_leave_type_id"
    t.float    "leave_taken",      limit: 24
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "available_leave",  limit: 24
    t.date     "leave_month_year"
  end

  create_table "mg_employee_payslip_components", force: true do |t|
    t.integer  "mg_employee_payslip_detail_id"
    t.integer  "mg_salary_component_id"
    t.integer  "mg_school_id"
    t.float    "amount",                        limit: 24
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "reason"
  end

  create_table "mg_employee_payslip_details", force: true do |t|
    t.integer  "mg_employee_id"
    t.float    "extra_leave_taken",                  limit: 24
    t.integer  "month"
    t.integer  "year"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "is_approved"
    t.float    "no_of_payable_days_in_the_month",    limit: 24
    t.float    "leaves_taken_till_date_in_the_year", limit: 24
    t.float    "leave_balance",                      limit: 24
    t.float    "total_leave",                        limit: 24
    t.float    "total_Gross_salary",                 limit: 24
    t.float    "total_net_amount",                   limit: 24
    t.float    "over_time",                          limit: 24
    t.boolean  "is_released"
    t.boolean  "is_editable"
    t.text     "reason"
  end

  create_table "mg_employee_payslips", force: true do |t|
    t.integer  "mg_employee_id"
    t.decimal  "payscale",       precision: 8, scale: 2
    t.date     "from_date"
    t.date     "to_date"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_employee_positions", force: true do |t|
    t.integer  "mg_employee_category_id"
    t.string   "position_name"
    t.boolean  "status"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_employee_position_id"
  end

  create_table "mg_employee_specializations", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_employee_subjects", force: true do |t|
    t.integer  "mg_employee_id"
    t.integer  "mg_subject_id"
    t.integer  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_employee_types", force: true do |t|
    t.string   "employee_type"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_employee_weekdays", force: true do |t|
    t.integer  "weekday"
    t.string   "name"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_employees", force: true do |t|
    t.integer  "mg_nationality_id"
    t.integer  "mg_employee_type_id"
    t.integer  "mg_employee_category_id"
    t.integer  "mg_employee_position_id"
    t.integer  "mg_employee_department_id"
    t.integer  "mg_reporting_manager_id"
    t.integer  "mg_employee_grade_id"
    t.integer  "mg_user_id"
    t.integer  "mg_manager_id"
    t.string   "emergency_contact_name"
    t.string   "emergency_contact_number"
    t.text     "hobby"
    t.text     "extra_curricular"
    t.text     "sport_activity"
    t.string   "language"
    t.string   "nationality"
    t.string   "employee_number"
    t.date     "joining_date"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "job_title"
    t.string   "qualification"
    t.text     "experience_detail"
    t.integer  "experience_year"
    t.integer  "experience_month"
    t.string   "status"
    t.string   "status_description"
    t.date     "date_of_birth"
    t.string   "marital_status"
    t.integer  "children_count"
    t.string   "father_name"
    t.string   "mother_name"
    t.string   "husband_name"
    t.string   "blood_group"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.binary   "photo_data"
    t.integer  "photo_file_size"
    t.string   "additional_detail"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "referred_by"
    t.string   "designation"
    t.boolean  "is_ltc_applicable"
    t.boolean  "is_referred"
    t.integer  "max_no_of_class"
    t.decimal  "pay_scale",                 precision: 8, scale: 2
    t.date     "last_working_day"
    t.boolean  "is_hod"
    t.boolean  "is_dean"
    t.integer  "hod_specialization_id"
  end

  add_index "mg_employees", ["first_name", "last_name", "date_of_birth", "father_name"], name: "mg_employee_unique_index", unique: true, using: :btree

  create_table "mg_entrance_exam_details", force: true do |t|
    t.integer  "mg_course_id"
    t.date     "start_date"
    t.time     "start_time"
    t.time     "end_time"
    t.text     "exam_venue"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_entrance_exam_venue_id"
  end

  create_table "mg_entrance_exam_venues", force: true do |t|
    t.text     "exam_venue"
    t.string   "institute_name"
    t.integer  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_event_committees", force: true do |t|
    t.string   "committee_name"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_event_planners", force: true do |t|
    t.integer  "mg_event_committee_id"
    t.string   "event_name"
    t.string   "description"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "message"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_event_privacies", force: true do |t|
    t.integer  "mg_event_id"
    t.string   "privacy"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_event_types", force: true do |t|
    t.string   "name"
    t.string   "event_color"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_events", force: true do |t|
    t.string   "title"
    t.integer  "mg_event_type_id"
    t.string   "event_privacy"
    t.text     "event_description"
    t.time     "start_time"
    t.time     "end_time"
    t.date     "event_date"
    t.date     "end_date"
    t.boolean  "all_day"
    t.boolean  "editable"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_event_committee_id"
  end

  create_table "mg_exam_groups", force: true do |t|
    t.string   "name"
    t.integer  "mg_batch_id"
    t.string   "exam_type"
    t.integer  "is_published"
    t.integer  "result_published"
    t.float    "maximum_mark",         limit: 24
    t.float    "minimum_mark",         limit: 24
    t.date     "exam_date"
    t.integer  "is_final_exam"
    t.integer  "cce_exam_category_id"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_exam_scores", force: true do |t|
    t.integer  "mg_student_id"
    t.integer  "mg_exam_id"
    t.integer  "marks"
    t.integer  "mg_grading_level_id"
    t.string   "remarks"
    t.boolean  "is_failed"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_exam_systems", force: true do |t|
    t.string   "grading_name"
    t.integer  "grading_system"
    t.text     "description"
    t.integer  "is_enabled"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_exams", force: true do |t|
    t.integer  "mg_exam_group_id"
    t.integer  "mg_subject_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.float    "maximum_marks",       limit: 24
    t.float    "minimum_marks",       limit: 24
    t.integer  "mg_grading_level_id"
    t.integer  "weightage"
    t.integer  "mg_event_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date_data"
    t.time     "start_time_data"
    t.time     "end_time_data"
    t.integer  "mg_batch_id"
  end

  create_table "mg_fa_criteria", force: true do |t|
    t.string   "fa_name"
    t.text     "description"
    t.integer  "mg_fa_group_id"
    t.integer  "sort_order"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_fa_groups", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "mg_cce_exam_category_id"
    t.integer  "mg_cce_grades_set_id"
    t.float    "max_marks",               limit: 24
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "assessment"
  end

  create_table "mg_fa_groups_subjects", force: true do |t|
    t.integer  "mg_subject_id"
    t.integer  "mg_fa_group_id"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "updated_by"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_faq_categories", force: true do |t|
    t.string   "category_name"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_faq_sub_categories", force: true do |t|
    t.integer  "mg_faq_category_id"
    t.string   "sub_category_name"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_faqs", force: true do |t|
    t.integer  "mg_faq_category_id"
    t.integer  "mg_faq_sub_category_id"
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
  end

  create_table "mg_fee_categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "item_category_name"
    t.integer  "mg_inventory_item_category_id"
    t.integer  "mg_inventory_item_id"
    t.integer  "mg_account_id"
  end

  create_table "mg_fee_category_batches", force: true do |t|
    t.integer  "mg_batch_id"
    t.integer  "mg_fee_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_fee_collection_discounts", force: true do |t|
    t.string   "mg_discount_type"
    t.string   "mg_discount_name"
    t.integer  "mg_discount_receiver_id"
    t.integer  "mg_fee_collection_id"
    t.string   "mg_discount"
    t.boolean  "is_percent"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_fee_collection_particulars", force: true do |t|
    t.string   "mg_fee_particular_name"
    t.string   "mg_fee_particular_description"
    t.string   "mg_fee_particular_amount"
    t.integer  "mg_fee_collection_id"
    t.integer  "mg_student_category_id"
    t.string   "mg_student_admission_number"
    t.integer  "mg_student_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_fee_collections", force: true do |t|
    t.string   "name"
    t.integer  "mg_fee_category_id"
    t.integer  "mg_batch_id"
    t.integer  "mg_fine_id"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "due_date"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "collection_type"
  end

  create_table "mg_fee_discounts", force: true do |t|
    t.string   "discount_type"
    t.string   "name"
    t.integer  "mg_receiver_id"
    t.integer  "mg_batch_id"
    t.integer  "mg_fee_category_id"
    t.string   "discount"
    t.boolean  "is_percent"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_fee_fine_dues", force: true do |t|
    t.integer  "mg_fee_fine_id"
    t.string   "days_after_due_date"
    t.string   "amount"
    t.boolean  "is_percent"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_fee_fine_particulars", force: true do |t|
    t.string   "fine_name"
    t.text     "description"
    t.string   "fine_from"
    t.float    "amount",                          limit: 24
    t.integer  "mg_batch_id"
    t.integer  "mg_student_category_id"
    t.integer  "mg_student_id"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "due_date"
    t.integer  "mg_item_consumption_id"
    t.integer  "mg_laboratory_subject_id"
    t.integer  "mg_laboratory_room_id"
    t.integer  "mg_inventory_item_id"
    t.integer  "mg_inventory_fine_particular_id"
    t.integer  "mg_account_id"
    t.boolean  "is_to_central"
  end

  create_table "mg_fee_fines", force: true do |t|
    t.string   "fine_name"
    t.text     "fine_description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_fee_particulars", force: true do |t|
    t.string   "fee_category"
    t.string   "name"
    t.string   "description"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "due_date"
    t.string   "amount"
    t.integer  "mg_batch_id"
    t.integer  "mg_particular_type_id"
    t.string   "admission_no"
    t.integer  "mg_student_category_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_account_id"
    t.boolean  "is_to_central"
  end

  create_table "mg_finance_fees", force: true do |t|
    t.integer  "mg_fee_collection_id"
    t.string   "transaction_id"
    t.integer  "student_id"
    t.boolean  "is_paid"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_finance_officers", force: true do |t|
    t.integer  "mg_employee_department_id"
    t.integer  "mg_employee_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_finance_transaction_details", force: true do |t|
    t.integer  "mg_transaction_id"
    t.integer  "mg_collection_id"
    t.integer  "mg_student_id"
    t.integer  "mg_fee_particular_id"
    t.integer  "mg_fee_fine_particular_id"
    t.float    "paid_amount",                   limit: 24
    t.boolean  "is_partial_payment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_fee_collection_discount_id"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "late_fee_fine_id"
    t.string   "detail_type"
  end

  create_table "mg_finance_transactions", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "amount"
    t.boolean  "fine_included"
    t.integer  "category_id"
    t.integer  "mg_student_id"
    t.integer  "finance_fee_id"
    t.date     "transaction_date"
    t.string   "fine_amount"
    t.integer  "master_transaction_id"
    t.integer  "finance_id"
    t.string   "finance_type"
    t.integer  "payee_id"
    t.string   "payee_type"
    t.string   "receipt_no"
    t.string   "voucher_no"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "payment_mode"
    t.date     "date_of_cheque"
    t.date     "date_of_draft"
    t.string   "cheque_number"
    t.string   "draft_number"
    t.string   "bankname_and_branch"
    t.string   "fees_from"
  end

  create_table "mg_fom_query_records", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_fom_transport_bookings", force: true do |t|
    t.date     "date_of_booking"
    t.time     "transport_time"
    t.string   "place_from"
    t.string   "place_to"
    t.string   "way_mode"
    t.integer  "mg_employee_category_id"
    t.integer  "mg_employee_position_id"
    t.integer  "mg_employee_id"
    t.text     "purpose"
    t.string   "status"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "remark"
    t.boolean  "is_cancelled"
  end

  create_table "mg_food_items", force: true do |t|
    t.string   "item_name"
    t.integer  "price"
    t.string   "category"
    t.text     "description"
    t.integer  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unit"
    t.string   "brand"
    t.integer  "quantity"
  end

  create_table "mg_get_togethers", force: true do |t|
    t.integer  "mg_alumni_get_together_id"
    t.integer  "mg_alumni_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_grade_components", force: true do |t|
    t.integer  "mg_employee_grade_id"
    t.integer  "mg_salary_component_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "amount",                 limit: 24
    t.boolean  "is_applicable"
  end

  create_table "mg_grading_levels", force: true do |t|
    t.string   "name"
    t.integer  "mg_batch_id"
    t.float    "min_score",     limit: 24
    t.string   "order"
    t.float    "credit_points", limit: 24
    t.text     "description"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_grouped_batches", force: true do |t|
    t.integer  "mg_batch_group_id"
    t.integer  "mg_batch_id"
    t.integer  "mg_school_id"
    t.integer  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_grouped_exam_reports", force: true do |t|
    t.integer  "mg_batch_id"
    t.integer  "mg_student_id"
    t.integer  "mg_exam_group_id"
    t.float    "marks",            limit: 24
    t.string   "score_type"
    t.integer  "mg_subject_id"
    t.integer  "mg_school_id"
    t.integer  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_grouped_exams", force: true do |t|
    t.integer  "mg_exam_group_id"
    t.integer  "mg_batch_id"
    t.float    "weightage",        limit: 24
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_guardian_files", force: true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "relation"
    t.date     "dob"
    t.string   "occupation"
    t.float    "income",             limit: 24
    t.string   "education"
    t.integer  "mg_user_file_id"
    t.integer  "mg_student_file_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_guardian_transport_requisitions", force: true do |t|
    t.integer  "mg_student_id"
    t.integer  "mg_transport_id"
    t.integer  "mg_transport_time_management_id"
    t.string   "confirmation_status"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "applied_date"
    t.integer  "mg_vehicle_id"
  end

  create_table "mg_guardians", force: true do |t|
    t.integer  "mg_ward_id"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "relation"
    t.date     "dob"
    t.integer  "mg_country_id"
    t.string   "occupation"
    t.string   "income"
    t.string   "education"
    t.integer  "mg_user_id"
    t.integer  "mg_student_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "has_login_access"
  end

  create_table "mg_guest_room_bookings", force: true do |t|
    t.integer  "mg_fom_room_creation_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "mg_employee_category_id"
    t.integer  "mg_employee_position_id"
    t.integer  "mg_employee_id"
    t.text     "purpose"
    t.string   "status"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "remark"
    t.boolean  "is_cancelled"
  end

  create_table "mg_guests", force: true do |t|
    t.string   "guest_name"
    t.text     "guest_details"
    t.string   "mobile_no"
    t.string   "email_id"
    t.string   "status"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_event_id"
  end

  create_table "mg_health_tests", force: true do |t|
    t.integer  "mg_check_up_schedule_id"
    t.string   "user_type"
    t.date     "date"
    t.integer  "mg_check_up_type_id"
    t.integer  "mg_employee_department_id"
    t.integer  "mg_batch_id"
    t.integer  "mg_student_id"
    t.integer  "mg_employee_id"
    t.string   "result"
    t.string   "recommendation"
    t.integer  "mg_checkup_particular_id"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_help_documents", force: true do |t|
    t.integer  "mg_school_id"
    t.string   "user_type"
    t.string   "name"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_homework_categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_hostel_attendances", force: true do |t|
    t.date     "absent_date"
    t.integer  "mg_student_id"
    t.integer  "mg_wing_id"
    t.integer  "is_approved"
    t.boolean  "is_lock"
    t.text     "reason"
    t.text     "morning_reason"
    t.text     "evening_reason"
    t.text     "morning_late_reason"
    t.text     "evening_late_reason"
    t.string   "time"
    t.string   "evening_late_time"
    t.boolean  "is_late_come"
    t.boolean  "is_evening_late_come"
    t.boolean  "absent_without_notice"
    t.integer  "mg_hostel_detail_id"
    t.boolean  "is_morning"
    t.boolean  "is_evening"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_hostel_details", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "category"
    t.integer  "total"
    t.integer  "occupancy"
    t.integer  "availability"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible_to_student"
  end

  create_table "mg_hostel_discipline_report_lists", force: true do |t|
    t.integer  "mg_hostel_discipline_report"
    t.integer  "mg_student_id"
    t.string   "status"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_hostel_discipline_reports", force: true do |t|
    t.integer  "mg_hostel_details_id"
    t.date     "date_of_report"
    t.text     "reason"
    t.text     "action_to_be_taken"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "mg_hostel_floors", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_user_id"
    t.integer  "mg_hostel_details_id"
  end

  create_table "mg_hostel_going_out_provisions", force: true do |t|
    t.text     "reason"
    t.date     "from_date"
    t.time     "start_time"
    t.date     "to_date"
    t.time     "end_time"
    t.string   "status"
    t.integer  "mg_student_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_hostel_details_id"
  end

  create_table "mg_hostel_health_managements", force: true do |t|
    t.integer  "mg_hostel_details_id"
    t.integer  "mg_hostel_floor_id"
    t.integer  "mg_hostel_room_id"
    t.integer  "mg_student_id"
    t.date     "date"
    t.text     "reason"
    t.string   "status"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_hostel_programme_quota", force: true do |t|
    t.integer  "mg_hostel_details_id"
    t.integer  "programme"
    t.integer  "max_occupancy"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_hostel_reallotment_requests", force: true do |t|
    t.integer  "mg_hostel_details_id"
    t.integer  "mg_hostel_floor_id"
    t.integer  "mg_hostel_room_type_id"
    t.integer  "mg_wing_id"
    t.integer  "mg_hostel_room_id"
    t.text     "reason"
    t.string   "status"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_student_id"
    t.string   "reallocated_room__number"
  end

  create_table "mg_hostel_room_types", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "capacity"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_user_id"
    t.integer  "mg_hostel_details_id"
  end

  create_table "mg_hostel_rooms", force: true do |t|
    t.integer  "mg_hostel_details_id"
    t.integer  "mg_hostel_floor_id"
    t.integer  "mg_hostel_room_type_id"
    t.string   "name"
    t.integer  "capacity"
    t.boolean  "is_occupiable"
    t.text     "reason"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "availability"
    t.boolean  "is_occupiable_old"
  end

  create_table "mg_hostel_rules", force: true do |t|
    t.integer  "mg_hostel_details_id"
    t.string   "name"
    t.text     "description"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_hostel_wardens", force: true do |t|
    t.integer  "mg_hostel_details_id"
    t.integer  "mg_employee_department_id"
    t.integer  "mg_employee_id"
    t.string   "user_name"
    t.integer  "mg_user_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_images", force: true do |t|
    t.integer  "mg_alumni_photo_gallery_id"
    t.string   "image"
    t.string   "video"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "mg_institute_rooms", force: true do |t|
    t.string   "room_no"
    t.integer  "mg_employee_specialization_id"
    t.integer  "capacity"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_inventory_fine_particulars", force: true do |t|
    t.string   "fine_name"
    t.text     "description"
    t.integer  "amount"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_inventory_issued_item_consumptions", force: true do |t|
    t.integer  "mg_inventory_item_consumption_id"
    t.string   "mg_consumer_type"
    t.integer  "mg_batch_id"
    t.integer  "mg_student_id"
    t.integer  "mg_department_id"
    t.integer  "mg_employee_id"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_inventory_item_categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_inventory_item_consumptions", force: true do |t|
    t.integer  "mg_inventory_item_category_id"
    t.integer  "mg_inventory_item_id"
    t.string   "item_prefix"
    t.string   "item_type"
    t.integer  "mg_inventory_room_id"
    t.integer  "mg_inventory_rack_id"
    t.integer  "quantity_available"
    t.integer  "quantity_consumed"
    t.integer  "mg_school_id"
    t.date     "consumption_date"
    t.string   "consumption_type"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "mg_student_id"
    t.integer  "mg_employee_id"
  end

  create_table "mg_inventory_item_damageds", force: true do |t|
    t.integer  "mg_inventory_item_consumption_id"
    t.date     "return_date"
    t.integer  "mg_employee_id"
    t.integer  "mg_student_id"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_inventory_item_managements", force: true do |t|
    t.integer  "mg_inventory_item_category_id"
    t.integer  "mg_inventory_item_id"
    t.string   "item_prefix"
    t.string   "label_text"
    t.string   "item_type"
    t.integer  "mg_inventory_room_id"
    t.integer  "mg_inventory_rack_id"
    t.integer  "quantity"
    t.integer  "minimum_quantity"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity_available"
    t.date     "date_of_expiry"
    t.string   "remark"
  end

  create_table "mg_inventory_item_returns", force: true do |t|
    t.integer  "mg_inventory_item_consumption_id"
    t.date     "return_date"
    t.integer  "mg_employee_id"
    t.integer  "mg_student_id"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_inventory_items", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "mg_category_id"
    t.string   "item_type"
    t.string   "prefix"
    t.text     "description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "minimum_quantity_required"
    t.integer  "mg_item_unit_id"
    t.boolean  "available_online"
    t.integer  "reserved_for_offline",      limit: 8
    t.integer  "online_price"
  end

  create_table "mg_inventory_managements", force: true do |t|
    t.integer  "mg_lab_id"
    t.integer  "mg_category_id"
    t.string   "item_name"
    t.text     "item_description"
    t.decimal  "quantity",                   precision: 10, scale: 0
    t.integer  "mg_unit_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "item_identification_number"
    t.date     "valid_upto"
    t.string   "item_location"
    t.integer  "mg_laboratory_subject_id"
    t.integer  "mg_laboratory_room_id"
  end

  create_table "mg_inventory_projection_items", force: true do |t|
    t.integer  "mg_inventory_projection_id"
    t.integer  "mg_item_id"
    t.integer  "mg_unit_type_id"
    t.integer  "no_of_unit"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_inventory_projections", force: true do |t|
    t.integer  "mg_store_id"
    t.integer  "mg_employee_id"
    t.string   "requisition_name"
    t.text     "description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.string   "status"
    t.text     "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
    t.integer  "mg_user_id"
  end

  create_table "mg_inventory_proposal_items", force: true do |t|
    t.integer  "mg_inventory_proposal_id"
    t.integer  "mg_item_id"
    t.integer  "mg_unit_type_id"
    t.integer  "no_of_unit"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.date     "date"
    t.integer  "mg_inventory_vendor_id"
    t.string   "remark_description"
    t.string   "po_number"
    t.string   "invoice_number"
  end

  create_table "mg_inventory_proposals", force: true do |t|
    t.integer  "mg_store_id"
    t.integer  "mg_employee_id"
    t.string   "requisition_name"
    t.text     "description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
    t.string   "status"
    t.text     "remark"
    t.integer  "mg_account_id"
    t.integer  "amount"
    t.boolean  "is_from_central"
    t.integer  "mg_user_id"
    t.string   "code"
  end

  create_table "mg_inventory_room_managements", force: true do |t|
    t.string   "room_no"
    t.integer  "mg_inventory_store_management_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_inventory_sales_data", force: true do |t|
    t.integer  "mg_inventory_item_category_id"
    t.date     "date_of_sales"
    t.float    "amount",                            limit: 24
    t.integer  "mg_inventory_item_id"
    t.float    "cost_per_unit",                     limit: 24
    t.float    "no_of_units",                       limit: 24
    t.float    "total",                             limit: 24
    t.integer  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_inventory_sales_information_id"
  end

  create_table "mg_inventory_sales_informations", force: true do |t|
    t.integer  "mg_inventory_item_category_id"
    t.date     "date_of_sales"
    t.float    "amount",                        limit: 24
    t.integer  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "customer_name"
    t.integer  "mg_account_id"
    t.boolean  "is_to_central"
  end

  create_table "mg_inventory_store_managements", force: true do |t|
    t.string   "store_name"
    t.text     "description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_inventory_store_managers", force: true do |t|
    t.integer  "mg_inventory_store_management_id"
    t.integer  "mg_employee_department_id"
    t.integer  "mg_employee_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_user_id"
  end

  create_table "mg_inventory_tables", force: true do |t|
    t.integer  "mg_lab_id"
    t.integer  "mg_category_id"
    t.date     "mg_purchase_date"
    t.date     "mg_used_date"
    t.time     "start_time"
    t.time     "end_time"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_inventory_vendor_items", force: true do |t|
    t.integer  "mg_vendor_id"
    t.integer  "mg_item_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unit_price"
  end

  create_table "mg_inventory_vendors", force: true do |t|
    t.string   "category"
    t.string   "name"
    t.string   "contact_name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.integer  "postal_code"
    t.string   "country"
    t.string   "phone_number"
    t.string   "fax_number"
    t.string   "email"
    t.text     "information"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "vendor_code"
  end

  create_table "mg_invitations", force: true do |t|
    t.boolean  "employee"
    t.boolean  "guardian"
    t.boolean  "student"
    t.integer  "mg_batch_id"
    t.integer  "mg_employee_department_id"
    t.integer  "mg_event_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "teacher"
    t.boolean  "alumni"
    t.integer  "time_table_year"
    t.integer  "mg_wing_id"
  end

  create_table "mg_invite_get_togethers", force: true do |t|
    t.integer  "mg_wing_id"
    t.string   "passout_year"
    t.integer  "mg_alumni_get_together_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_item_consumptions", force: true do |t|
    t.integer  "mg_lab_id"
    t.integer  "mg_category_id"
    t.integer  "mg_item_id"
    t.decimal  "quantity_consumption",       precision: 10, scale: 0
    t.date     "date"
    t.string   "consumption_type"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_course_id"
    t.integer  "mg_batch_id"
    t.integer  "mg_student_id"
    t.date     "return_date"
    t.integer  "mg_item_type_id"
    t.integer  "mg_laboratory_subject_id"
    t.integer  "mg_laboratory_room_id"
    t.integer  "mg_laboratory_item_type_id"
  end

  create_table "mg_item_informations", force: true do |t|
    t.integer  "mg_purchase_id"
    t.integer  "mg_category_id"
    t.string   "item_name"
    t.decimal  "cost",           precision: 10, scale: 0
    t.decimal  "unit",           precision: 10, scale: 0
    t.decimal  "total",          precision: 10, scale: 0
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "valid_upto"
  end

  create_table "mg_item_purchases", force: true do |t|
    t.integer  "mg_lab_id"
    t.string   "vendor_name"
    t.date     "date"
    t.decimal  "amount_paid",              precision: 10, scale: 0
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_laboratory_subject_id"
    t.integer  "mg_room_id"
  end

  create_table "mg_lab_inventories", force: true do |t|
    t.integer  "mg_lab_id"
    t.string   "category_name"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_laboratory_item_id"
    t.string   "prefix"
  end

  create_table "mg_lab_units", force: true do |t|
    t.string   "unit_name"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_laboratory_incharges", force: true do |t|
    t.integer  "mg_employee_id"
    t.string   "incharge_type"
    t.integer  "mg_subject_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_laboratory_items", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_issuable"
  end

  create_table "mg_laboratory_subjects", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_laboratory_tables", force: true do |t|
    t.string   "lab_name"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_labs", force: true do |t|
    t.string   "lab_name"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_laboratory_subject_id"
    t.string   "room_no"
  end

  create_table "mg_languages", force: true do |t|
    t.integer  "mg_user_id"
    t.string   "language_name"
    t.string   "read"
    t.string   "write"
    t.string   "speak"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_library_employees", force: true do |t|
    t.integer  "mg_employee_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "designation"
  end

  create_table "mg_library_settings", force: true do |t|
    t.integer  "max_books_issuable"
    t.integer  "max_borrow_days"
    t.float    "fine_for_late_return",                 limit: 24
    t.integer  "max_days_on_reservation_after_return"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_fee_category_id"
  end

  create_table "mg_library_stack_managements", force: true do |t|
    t.string   "room_no"
    t.string   "rack_no"
    t.string   "first_letter_of_title"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_mail_statuses", force: true do |t|
    t.integer  "status_code"
    t.string   "email_addrs_to"
    t.string   "email_addrs_by"
    t.string   "email_subject"
    t.string   "email_server_description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_manage_subjects", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_management_quota", force: true do |t|
    t.integer  "mg_user_id"
    t.string   "name"
    t.string   "position"
    t.string   "employee_id"
    t.date     "joining_date"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_master_payment_types", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "mg_account_id"
    t.boolean  "is_to_central"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_meal_categories", force: true do |t|
    t.string   "name"
    t.integer  "priority"
    t.text     "description"
    t.integer  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_meeting_details", force: true do |t|
    t.integer  "mg_meeting_room_id"
    t.date     "start_date"
    t.time     "start_time"
    t.date     "end_date"
    t.time     "end_time"
    t.integer  "mg_employee_id"
    t.text     "meeting_purpose"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number_of_attendees"
    t.boolean  "is_cancelled"
  end

  create_table "mg_meeting_planner_foms", force: true do |t|
    t.string   "meeting_with"
    t.text     "purpose"
    t.text     "description"
    t.datetime "start_date_of_meeting"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "status"
    t.text     "remark"
    t.text     "principal_remark"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_principal"
    t.datetime "end_date_of_meeting"
    t.date     "date_of_meeting"
    t.boolean  "is_reschedule"
  end

  create_table "mg_meeting_rooms", force: true do |t|
    t.string   "room_no"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type_of_room"
    t.integer  "capacity"
  end

  create_table "mg_models", force: true do |t|
    t.string   "model_name"
    t.integer  "index"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_multi_school_accesses", force: true do |t|
    t.integer  "mg_user_id"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_my_questions", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "mg_employee_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_batch_id"
  end

  create_table "mg_notifications", force: true do |t|
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.string   "subject"
    t.text     "description"
    t.boolean  "status"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_observation_groups", force: true do |t|
    t.string   "name"
    t.string   "header_name"
    t.text     "description"
    t.integer  "mg_cce_grades_set_id"
    t.integer  "observation_kind"
    t.string   "max_marks_float"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_observations", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "mg_observation_group_id"
    t.integer  "sort_order"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "updated_by"
    t.integer  "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_particular_specializations", force: true do |t|
    t.integer  "mg_employee_id"
    t.integer  "mg_employee_specialization_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_particular_types", force: true do |t|
    t.string   "particular_name"
    t.string   "description"
    t.integer  "mg_fee_category_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_inventory_item_id"
  end

  create_table "mg_payment_gateways", force: true do |t|
    t.integer  "mg_master_payment_type_id"
    t.integer  "mg_wing_id"
    t.string   "time_table_year"
    t.integer  "mg_employee_specialization_id"
    t.integer  "mg_alumni_id"
    t.float    "amount",                        limit: 24
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "upated_by"
    t.integer  "mg_finance_fee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_account_id"
    t.boolean  "is_to_central"
  end

  create_table "mg_payment_types", force: true do |t|
    t.string   "payment_type_name"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_payslip_leave_details", force: true do |t|
    t.integer  "mg_employee_payslip_detail_id"
    t.integer  "mg_employee_leave_type_id"
    t.float    "leave_taken",                   limit: 24
    t.float    "available_leave",               limit: 24
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_permissions", force: true do |t|
    t.integer  "mg_model_id"
    t.integer  "mg_action_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_phone_files", force: true do |t|
    t.string   "phone_number"
    t.string   "phone_type"
    t.boolean  "notification"
    t.boolean  "subscription"
    t.integer  "mg_user_file_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_phones", force: true do |t|
    t.string   "phone_number"
    t.string   "phone_type"
    t.boolean  "notification"
    t.boolean  "subscription"
    t.integer  "mg_user_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_placement_student_details", force: true do |t|
    t.string   "name"
    t.string   "resume_headline"
    t.string   "current_position"
    t.date     "date_of_birth"
    t.string   "last_degree"
    t.string   "year_of_passing"
    t.string   "functional_area"
    t.string   "educational_qualification"
    t.integer  "experience"
    t.text     "technical_skills"
    t.text     "soft_skills"
    t.integer  "salary_expected"
    t.text     "address"
    t.integer  "contact_number"
    t.string   "email_id"
    t.string   "current_location"
    t.string   "preferred_location"
    t.integer  "mg_student_id"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_poll_data", force: true do |t|
    t.integer  "mg_question_id"
    t.integer  "mg_alumni_user_id"
    t.integer  "answer"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_poll_option_alumni_particulars", force: true do |t|
    t.integer  "mg_poll_option_alumni_id"
    t.string   "paticular"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count"
  end

  create_table "mg_poll_option_alumnis", force: true do |t|
    t.integer  "mg_alumni_polling_id"
    t.string   "paticular"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_poll_question_alumnis", force: true do |t|
    t.text     "question"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "due_date"
    t.date     "start_date"
  end

  create_table "mg_postal_records", force: true do |t|
    t.string   "recipient_name"
    t.text     "address"
    t.string   "dispatch_number"
    t.string   "transaction_flow"
    t.date     "received_date"
    t.string   "mode_of_dispatch"
    t.string   "category"
    t.string   "dispatcher"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_type"
    t.integer  "mg_batch_id"
    t.integer  "mg_student_id"
    t.integer  "mg_employee_department_id"
    t.integer  "mg_employee_id"
  end

  create_table "mg_previous_education_files", force: true do |t|
    t.string   "school_name"
    t.string   "class"
    t.string   "grade"
    t.string   "year"
    t.integer  "mg_student_file_id"
    t.float    "marks_obtained",                   limit: 24
    t.float    "total_marks",                      limit: 24
    t.boolean  "is_transfer_certificate_produced"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_previous_educations", force: true do |t|
    t.string   "school_name"
    t.string   "course"
    t.string   "grade"
    t.integer  "year"
    t.integer  "mg_student_id"
    t.integer  "marks_obtained"
    t.decimal  "total_marks",                      precision: 10, scale: 0
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_transfer_certificate_produced"
  end

  create_table "mg_query_records", force: true do |t|
    t.string   "query_number"
    t.string   "caller_name"
    t.string   "phone_number"
    t.integer  "mg_caller_category_fom_id"
    t.text     "query"
    t.integer  "mg_fom_query_record_id"
    t.text     "response_given"
    t.text     "follow_up_action"
    t.text     "action_required"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_principal_required"
    t.integer  "mg_caller_category_id"
    t.date     "date_of_query"
  end

  create_table "mg_ranking_levels", force: true do |t|
    t.string   "name"
    t.float    "gpa",                limit: 24
    t.float    "marks",              limit: 24
    t.integer  "subject_count"
    t.integer  "priority"
    t.integer  "full_course"
    t.integer  "mg_course_id"
    t.string   "subject_limit_type"
    t.string   "marks_limit_type"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_report_types", force: true do |t|
    t.string   "report_type_name"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_resource_categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_resource_informations", force: true do |t|
    t.integer  "mg_resource_category_id"
    t.integer  "mg_resource_type_id"
    t.string   "name"
    t.string   "author"
    t.string   "volume"
    t.integer  "year"
    t.string   "publication"
    t.string   "isbn"
    t.integer  "mg_course_id"
    t.integer  "mg_subject_id"
    t.float    "cost",                    limit: 24
    t.integer  "no_of_copy"
    t.float    "total",                   limit: 24
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_resource_purchase_id"
  end

  create_table "mg_resource_inventories", force: true do |t|
    t.integer  "mg_resource_category_id"
    t.integer  "mg_resource_type_id"
    t.string   "resource_number"
    t.string   "name"
    t.string   "author"
    t.string   "volume"
    t.string   "year"
    t.string   "publication"
    t.integer  "isbn"
    t.integer  "mg_course_id"
    t.integer  "mg_subject_id"
    t.string   "stack_reference"
    t.float    "cost",                    limit: 24
    t.boolean  "non_issuable"
    t.boolean  "is_damaged"
    t.boolean  "is_lost"
    t.string   "status"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "issued_to"
    t.date     "due_date"
    t.date     "issued_date"
    t.string   "user_type"
    t.integer  "renewal_count"
  end

  create_table "mg_resource_purchases", force: true do |t|
    t.string   "vendor_name"
    t.date     "date_of_purchase"
    t.float    "amount_paid",      limit: 24
    t.string   "invoice_number"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_resource_types", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "mg_resource_category_id"
    t.integer  "max_issuable_count"
    t.integer  "max_borrow_day"
    t.integer  "renewal_period"
    t.integer  "max_renewals_allowed"
    t.string   "prefix"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "fine_per_day",            limit: 24
    t.boolean  "is_non_issuable"
  end

  create_table "mg_roles", force: true do |t|
    t.string   "role_name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_roles_permissions", force: true do |t|
    t.integer  "mg_role_id"
    t.integer  "mg_permission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_school_id"
  end

  create_table "mg_salary_components", force: true do |t|
    t.string   "name"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_deduction"
    t.integer  "mg_account_id"
    t.boolean  "is_from_central"
  end

  create_table "mg_schools", force: true do |t|
    t.string   "school_name"
    t.string   "school_code"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "country"
    t.integer  "country_code"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "start_time"
    t.string   "end_time"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.integer  "pin_code"
    t.string   "landmark"
    t.string   "mobile_number"
    t.string   "email_id"
    t.string   "fax_number"
    t.string   "language"
    t.string   "date_format"
    t.string   "timezone"
    t.string   "currency_type"
    t.string   "affilicated_to"
    t.string   "grading_system"
    t.binary   "school_logo"
    t.string   "reg_num"
    t.boolean  "is_active"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subdomain"
    t.date     "mg_leave_calendar_start_date"
    t.boolean  "is_test_center"
    t.boolean  "disable_entrance_exam_test"
    t.integer  "mg_fee_category_id"
    t.integer  "exam_mg_fee_category_id"
  end

  create_table "mg_sibiling_files", force: true do |t|
    t.string   "name"
    t.string   "relation"
    t.date     "admission_date"
    t.string   "admission_number"
    t.integer  "mg_user_file_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_siblings", force: true do |t|
    t.integer  "mg_user_id"
    t.string   "name"
    t.string   "relation"
    t.integer  "mg_course_id"
    t.integer  "mg_batch_id"
    t.integer  "roll_no"
    t.date     "admission_date"
    t.string   "admission_no"
    t.boolean  "is_sibling"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_specializations", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_sport_employee_data_results", force: true do |t|
    t.integer  "mg_sports_result_id"
    t.integer  "mg_employee_id"
    t.string   "rank"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_sport_games", force: true do |t|
    t.string   "name"
    t.string   "game_type"
    t.text     "description"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "activity_game_type"
  end

  create_table "mg_sport_payslip_components", force: true do |t|
    t.integer  "mg_employee_payslip_detail_id"
    t.integer  "mg_sports_pay_deduction_id"
    t.integer  "amount"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deduction"
  end

  create_table "mg_sport_schedules", force: true do |t|
    t.string   "game_type"
    t.integer  "mg_sport_game_id"
    t.integer  "mg_sport_team_id1"
    t.integer  "mg_sport_team_id2"
    t.string   "guest_team"
    t.date     "start_date"
    t.time     "start_time"
    t.date     "end_date"
    t.time     "end_time"
    t.string   "venue"
    t.string   "winner"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_sport_student_data_results", force: true do |t|
    t.integer  "mg_sports_result_id"
    t.integer  "mg_students_id"
    t.string   "rank"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_sport_team_employees", force: true do |t|
    t.integer  "mg_sport_team_id"
    t.integer  "mg_employee_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_sport_team_students", force: true do |t|
    t.integer  "mg_sport_team_id"
    t.integer  "mg_student_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_sport_teams", force: true do |t|
    t.string   "game_type"
    t.integer  "mg_sport_game_id"
    t.string   "team_name"
    t.string   "team_of"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_sports_bed_assignments", force: true do |t|
    t.integer  "mg_sports_bed_details_id"
    t.date     "admitted_date"
    t.time     "admitted_time"
    t.date     "discharge_date"
    t.time     "discharge_time"
    t.string   "user_id"
    t.string   "status"
    t.integer  "mg_doctor_id"
    t.text     "comments"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_sports_bed_details", force: true do |t|
    t.string   "bed_no"
    t.text     "description"
    t.string   "status"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_sports_fine_students", force: true do |t|
    t.integer  "mg_sports_fine_id"
    t.integer  "mg_student_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_sports_fines", force: true do |t|
    t.string   "fine_name"
    t.text     "description"
    t.integer  "mg_account_id"
    t.integer  "amount"
    t.integer  "mg_batches_id"
    t.integer  "mg_student_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_sports_item_consumptions", force: true do |t|
    t.integer  "mg_inventory_item_category_id"
    t.integer  "mg_inventory_item_id"
    t.string   "item_prefix"
    t.string   "item_type"
    t.integer  "mg_inventory_room_id"
    t.integer  "mg_inventory_rack_id"
    t.integer  "quantity_available"
    t.integer  "quantity_consumed"
    t.string   "consumption_type"
    t.date     "consumption_date"
    t.text     "description"
    t.integer  "mg_student_id"
    t.integer  "mg_employee_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_sports_item_managements", force: true do |t|
    t.integer  "mg_inventory_item_category_id"
    t.integer  "mg_inventory_item_id"
    t.string   "item_prefix"
    t.string   "label_text"
    t.integer  "mg_inventory_room_id"
    t.integer  "mg_inventory_rack_id"
    t.integer  "quantity"
    t.integer  "quantity_available"
    t.date     "date_of_expiry"
    t.text     "remark"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_sports_pay_deductiion_lists", force: true do |t|
    t.integer  "mg_pay_deduction_details_id"
    t.integer  "mg_employee_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_sports_pay_deductions", force: true do |t|
    t.string   "mm_yyyy"
    t.integer  "mg_employee_category_id"
    t.integer  "mg_employee_department_id"
    t.integer  "mg_employee_id"
    t.integer  "amount"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "mg_school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "is_central"
    t.boolean  "is_account"
    t.integer  "month"
    t.integer  "year"
    t.boolean  "deduction"
  end

  create_table "mg_sports_results", force: true do |t|
    t.integer  "mg_event_committee_id"
    t.integer  "mg_event_id"
    t.date     "date_of_event"
    t.integer  "mg_sport_game_id"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "game_type"
    t.integer  "mg_sport_team_id1"
    t.integer  "mg_sport_team_id2"
    t.string   "guest_team"
    t.text     "venue"
    t.text     "winner"
    t.string   "sport_type"
    t.integer  "mg_sport_team_id"
  end

  create_table "mg_student_admissions", force: true do |t|
    t.date     "date_of_birth"
    t.integer  "mg_course_id"
    t.string   "grade"
    t.integer  "year"
    t.string   "course"
    t.boolean  "is_sibling"
    t.string   "is_selected_for_entrance_test"
    t.string   "is_shortlisted_for_admission"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "blood_group"
    t.string   "birth_place"
    t.string   "nationality"
    t.string   "language"
    t.string   "religion"
    t.string   "mg_c_address_line1"
    t.string   "mg_c_address_line2"
    t.string   "mg_c_street"
    t.string   "mg_c_landmark"
    t.string   "mg_c_city"
    t.string   "mg_c_state"
    t.integer  "mg_c_pin_code"
    t.string   "mg_c_country"
    t.string   "mg_p_address_line1"
    t.string   "mg_p_address_line2"
    t.string   "mg_p_street"
    t.string   "mg_p_landmark"
    t.string   "mg_p_city"
    t.string   "mg_p_state"
    t.integer  "mg_p_pin_code"
    t.string   "mg_p_country"
    t.integer  "phone_number",                  limit: 8
    t.integer  "mobile_number",                 limit: 8
    t.string   "mg_email_id"
    t.integer  "amount"
    t.string   "school_name"
    t.integer  "marks_obtained"
    t.integer  "total_marks"
    t.boolean  "has_paid"
    t.integer  "mg_user_id"
    t.boolean  "hall_ticket_release"
    t.string   "guardian_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "selection_index",               limit: 24
    t.integer  "exam_total_marks"
    t.float    "obtained_marks",                limit: 24
    t.integer  "student_temporary_id"
    t.float    "previous_education_weightage",  limit: 24
    t.float    "entrance_exam_weightage",       limit: 24
    t.integer  "mg_batch_id"
    t.integer  "mg_student_category_id"
    t.boolean  "has_previous_edcuation"
    t.integer  "mg_entrance_exam_details_id"
  end

  create_table "mg_student_attendances", force: true do |t|
    t.integer  "mg_student_id"
    t.integer  "mg_period_table_entry_id"
    t.integer  "mg_class_timing_id"
    t.boolean  "is_halfday"
    t.boolean  "is_afternoon"
    t.string   "reason"
    t.date     "absent_date"
    t.integer  "mg_batch_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_student_categories", force: true do |t|
    t.string   "name"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_student_files", force: true do |t|
    t.string   "admission_number"
    t.string   "nationality"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "blood_group"
    t.string   "birth_place"
    t.string   "language"
    t.string   "religion"
    t.integer  "mg_user_file_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_student_guardian_admissions", force: true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "relation"
    t.date     "date_of_birth"
    t.string   "occupation"
    t.integer  "income"
    t.string   "education"
    t.integer  "mg_student_id"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "street"
    t.string   "landmark"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "pin_code"
    t.integer  "phone_number",  limit: 8
    t.integer  "mobile_number", limit: 8
    t.string   "email_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_student_guardians", force: true do |t|
    t.integer  "mg_student_id"
    t.integer  "mg_guardians_id"
    t.string   "relation"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_login_access"
  end

  create_table "mg_student_hostel_application_forms", force: true do |t|
    t.integer  "mg_student_id"
    t.integer  "mg_guardian_id"
    t.integer  "mg_course_id"
    t.integer  "mg_batch_id"
    t.string   "admission_number"
    t.date     "date_of_application"
    t.string   "mobile_no"
    t.string   "email_id"
    t.text     "contact_address"
    t.string   "status"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_hostel_details_id"
    t.string   "rejected_by"
    t.string   "reason"
  end

  create_table "mg_student_item_consumptions", force: true do |t|
    t.integer  "mg_student_id"
    t.integer  "mg_course_id"
    t.integer  "mg_batch_id"
    t.integer  "mg_item_consumption_id"
    t.string   "consumption_type"
    t.integer  "mg_item_id"
    t.string   "quantity_consumption"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_student_scholarships", force: true do |t|
    t.integer  "mg_user_id"
    t.string   "name"
    t.string   "amount"
    t.string   "frequency"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_students", force: true do |t|
    t.string   "admission_number"
    t.string   "nationality"
    t.text     "extra_curricular"
    t.text     "health_record"
    t.text     "class_record"
    t.text     "hobby"
    t.text     "sport_activity"
    t.string   "class_roll_number"
    t.date     "admission_date"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.integer  "mg_batch_id"
    t.integer  "mg_course_id"
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "blood_group"
    t.string   "birth_place"
    t.integer  "mg_nationality_id"
    t.string   "language"
    t.string   "religion"
    t.integer  "mg_student_catagory_id"
    t.boolean  "is_sms_enable"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "status_description"
    t.boolean  "is_active"
    t.boolean  "has_paid_fees"
    t.integer  "mg_user_id"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_student_admission_id"
  end

  create_table "mg_subjects", force: true do |t|
    t.integer  "mg_course_id"
    t.string   "subject_name"
    t.string   "subject_code"
    t.integer  "max_weekly_class"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_core"
    t.boolean  "is_lab"
    t.integer  "no_of_classes"
    t.integer  "mg_wing_id"
  end

  create_table "mg_syllabus_trackers", force: true do |t|
    t.integer  "mg_employee_id"
    t.integer  "mg_syllabus_id"
    t.integer  "mg_unit_id"
    t.integer  "mg_topic_id"
    t.date     "date"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "expected_class"
    t.integer  "mg_batch_id"
  end

  create_table "mg_syllabuses", force: true do |t|
    t.integer  "mg_subject_id"
    t.string   "name"
    t.text     "description"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_time_table_change_entries", force: true do |t|
    t.integer  "mg_time_table_entry_id"
    t.integer  "mg_batch_id"
    t.integer  "mg_class_timing_id"
    t.integer  "mg_timetable_id"
    t.integer  "mg_subject_id"
    t.integer  "mg_employee_id"
    t.date     "date"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_permanent"
    t.integer  "old_mg_employee_id"
    t.integer  "old_mg_batch_id"
    t.integer  "old_mg_subject_id"
  end

  create_table "mg_time_table_entries", force: true do |t|
    t.integer  "mg_batch_id"
    t.integer  "mg_weekday_id"
    t.integer  "mg_class_timings_id"
    t.integer  "mg_subject_id"
    t.integer  "mg_employee_id"
    t.integer  "mg_timetable_id"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_time_tables", force: true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_topics", force: true do |t|
    t.integer  "mg_unit_id"
    t.integer  "mg_syllabus_id"
    t.string   "topic_name"
    t.text     "description"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "time_alloted"
  end

  create_table "mg_transport_time_managements", force: true do |t|
    t.integer  "mg_transport_id"
    t.string   "bus_stop_name"
    t.time     "pick_up_time"
    t.time     "drop_time"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_transports", force: true do |t|
    t.string   "route_name"
    t.text     "description"
    t.integer  "mg_vehicle_id"
    t.integer  "mg_employee_id"
    t.time     "drop_start_time"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_employee_category_id"
    t.integer  "mg_employee_position_id"
  end

  create_table "mg_units", force: true do |t|
    t.integer  "mg_syllabus_id"
    t.string   "unit_name"
    t.text     "description"
    t.integer  "hour"
    t.integer  "min"
    t.integer  "time"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "is_deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_user_albums", force: true do |t|
    t.integer  "mg_album_id"
    t.integer  "mg_batch_id"
    t.integer  "mg_employee_department_id"
    t.boolean  "accessable_to_employees"
    t.boolean  "accessable_to_students"
    t.boolean  "accessable_to_guardians"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accessable_teacher"
  end

  create_table "mg_user_files", force: true do |t|
    t.string   "user_name"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "user_type"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_user_roles", force: true do |t|
    t.integer  "mg_user_id"
    t.integer  "mg_role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mg_user_roles", ["mg_user_id", "mg_role_id"], name: "index_mg_user_roles_on_mg_user_id_and_mg_role_id", using: :btree

  create_table "mg_users", force: true do |t|
    t.string   "user_name"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "reset_password_code"
    t.datetime "reset_password_code_until"
    t.string   "user_type"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mg_student_admission_id"
    t.integer  "mg_specialization_id"
  end

  create_table "mg_vaccination_details", force: true do |t|
    t.integer  "mg_vaccination_id"
    t.integer  "mg_student_id"
    t.integer  "mg_batch_id"
    t.integer  "mg_time_table_id"
    t.date     "due_date"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "age_recommended"
    t.boolean  "is_particular_student"
    t.date     "date"
  end

  create_table "mg_vaccinations", force: true do |t|
    t.string   "name"
    t.string   "age_recommended"
    t.text     "description"
    t.integer  "mg_school_id"
    t.boolean  "is_deleted"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_vehicles", force: true do |t|
    t.string   "vehicle_number"
    t.string   "make"
    t.string   "model"
    t.date     "date_of_purchase"
    t.integer  "no_of_seats"
    t.date     "Current_insurance_due_date"
    t.date     "last_service_date"
    t.date     "next_service_date"
    t.boolean  "is_under_repair"
    t.date     "repair_completion_date"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "last_insurance_amount",      limit: 24
    t.string   "vehicle_status"
    t.integer  "mg_transport_id"
    t.integer  "mg_employee_id"
    t.time     "drop_start_time"
    t.integer  "mg_employee_position_id"
    t.integer  "mg_employee_category_id"
  end

  create_table "mg_weekdays", force: true do |t|
    t.integer  "mg_batch_id"
    t.integer  "mg_wing_id"
    t.string   "weekday"
    t.string   "name"
    t.integer  "sort_order"
    t.integer  "day_of_week"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mg_wings", force: true do |t|
    t.string   "wing_name"
    t.boolean  "status"
    t.boolean  "is_deleted"
    t.integer  "mg_school_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "blog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["blog_id"], name: "index_posts_on_blog_id", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

end
