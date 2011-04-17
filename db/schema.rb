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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110417061158) do

  create_table "bookreceipts", :force => true do |t|
    t.string   "book_no"
    t.string   "po_no"
    t.string   "invoice_no"
    t.string   "isbn"
    t.integer  "title_id",   :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "crate_id",   :precision => 38, :scale => 0
  end

  create_table "boxes", :force => true do |t|
    t.integer  "box_no",     :precision => 38, :scale => 0
    t.string   "po_no"
    t.string   "invoice_no"
    t.integer  "total_cnt",  :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "crate_id",   :precision => 38, :scale => 0
  end

  create_table "corelist", :force => true do |t|
    t.string  "isbn",          :limit => 30,                                :null => false
    t.string  "title"
    t.string  "author"
    t.string  "publisher"
    t.integer "publishercode",               :precision => 38, :scale => 0
    t.integer "price",                       :precision => 38, :scale => 0
    t.string  "currency",      :limit => 30
    t.string  "category"
    t.string  "subcategory"
    t.integer "qty",                         :precision => 38, :scale => 0
    t.decimal "branchid",                                                   :null => false
  end

  create_table "corelist_bkp", :id => false, :force => true do |t|
    t.string  "isbn",          :limit => 30,                                :null => false
    t.string  "title"
    t.string  "author"
    t.string  "publisher"
    t.integer "publishercode",               :precision => 38, :scale => 0
    t.integer "price",                       :precision => 38, :scale => 0
    t.string  "currency",      :limit => 30
    t.string  "category"
    t.string  "subcategory"
    t.integer "qty",                         :precision => 38, :scale => 0
    t.decimal "branchid"
  end

  create_table "crates", :force => true do |t|
    t.string   "po_no"
    t.string   "invoice_no"
    t.integer  "total_cnt",  :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enrichedtitle_versions", :force => true do |t|
    t.integer  "enrichedtitle_id", :precision => 38, :scale => 0
    t.integer  "version",          :precision => 38, :scale => 0
    t.integer  "title_id",         :precision => 38, :scale => 0
    t.string   "title"
    t.integer  "publisher_id",     :precision => 38, :scale => 0
    t.string   "isbn"
    t.string   "language"
    t.string   "category"
    t.string   "subcategory"
    t.string   "isbn10"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "verified"
    t.string   "author"
    t.string   "isbnvalid"
    t.integer  "listprice",        :precision => 38, :scale => 0
    t.string   "currency"
    t.string   "enriched"
  end

  add_index "enrichedtitle_versions", ["enrichedtitle_id"], :name => "i_enr_ver_enr_id", :tablespace => "users"

  create_table "enrichedtitles", :force => true do |t|
    t.integer  "title_id",     :precision => 38, :scale => 0
    t.string   "title"
    t.integer  "publisher_id", :precision => 38, :scale => 0
    t.string   "isbn"
    t.string   "language"
    t.string   "category"
    t.string   "subcategory"
    t.string   "isbn10"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version",      :precision => 38, :scale => 0
    t.string   "verified"
    t.string   "author"
    t.string   "isbnvalid"
    t.integer  "listprice",    :precision => 38, :scale => 0
    t.string   "currency"
    t.string   "enriched"
  end

  create_table "enrichedtitles_bkp", :id => false, :force => true do |t|
    t.integer  "id",           :precision => 38, :scale => 0, :null => false
    t.integer  "title_id",     :precision => 38, :scale => 0
    t.string   "title"
    t.integer  "publisher_id", :precision => 38, :scale => 0
    t.string   "isbn"
    t.string   "language"
    t.string   "category"
    t.string   "subcategory"
    t.string   "isbn10"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version",      :precision => 38, :scale => 0
    t.string   "verified"
    t.string   "author"
    t.string   "isbnvalid"
    t.integer  "listprice",    :precision => 38, :scale => 0
    t.string   "currency"
    t.string   "enriched"
  end

  create_table "invoices", :force => true do |t|
    t.string   "invoice_no"
    t.integer  "po_id",           :precision => 38, :scale => 0
    t.datetime "date_of_receipt"
    t.integer  "quantity",        :precision => 38, :scale => 0
    t.decimal  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "boxes_cnt",       :precision => 38, :scale => 0
  end

  create_table "pos", :force => true do |t|
    t.string   "code"
    t.integer  "supplier_id",                 :precision => 38, :scale => 0
    t.integer  "branch_id",                   :precision => 38, :scale => 0
    t.datetime "raised_on"
    t.integer  "titles_cnt",                  :precision => 38, :scale => 0
    t.integer  "copies_cnt",                  :precision => 38, :scale => 0
    t.string   "status"
    t.string   "user"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "discount",                    :precision => 38, :scale => 0
    t.integer  "publisher_id", :limit => nil
    t.string   "typeofpo"
    t.decimal  "convrate"
    t.decimal  "grossamt"
    t.decimal  "netamt"
    t.decimal  "orgunit"
    t.decimal  "suborgunit"
    t.decimal  "expensehead"
    t.datetime "payby1"
    t.decimal  "payableamt1"
    t.datetime "payby2"
    t.decimal  "payableamt2"
    t.datetime "payby3"
    t.decimal  "payableamt3"
    t.string   "narration"
  end

  create_table "procurementitemes_bkp2", :id => false, :force => true do |t|
    t.integer  "id",               :precision => 38, :scale => 0, :null => false
    t.string   "source"
    t.integer  "source_id",        :precision => 38, :scale => 0
    t.integer  "enrichedtitle_id", :precision => 38, :scale => 0
    t.string   "isbn"
    t.string   "status"
    t.string   "po_number"
    t.string   "book_number"
    t.string   "cancel_reason"
    t.integer  "deferred_by",      :precision => 38, :scale => 0
    t.datetime "last_action_date"
    t.integer  "supplier_id",      :precision => 38, :scale => 0
    t.datetime "expiry_date"
    t.integer  "member_id",        :precision => 38, :scale => 0
    t.string   "card_id"
    t.integer  "branch_id",        :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",         :precision => 38, :scale => 0
  end

  create_table "procurementitems", :force => true do |t|
    t.string   "source"
    t.integer  "source_id",        :precision => 38, :scale => 0
    t.integer  "enrichedtitle_id", :precision => 38, :scale => 0
    t.string   "isbn"
    t.string   "status"
    t.string   "po_number"
    t.string   "cancel_reason"
    t.integer  "deferred_by",      :precision => 38, :scale => 0
    t.datetime "last_action_date"
    t.integer  "supplier_id",      :precision => 38, :scale => 0
    t.datetime "expiry_date"
    t.integer  "member_id",        :precision => 38, :scale => 0
    t.string   "card_id"
    t.integer  "branch_id",        :precision => 38, :scale => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",         :precision => 38, :scale => 0
  end

  create_table "procurementitems_bkp", :id => false, :force => true do |t|
    t.integer  "id",               :precision => 38, :scale => 0, :null => false
    t.string   "source"
    t.integer  "source_id",        :precision => 38, :scale => 0
    t.integer  "enrichedtitle_id", :precision => 38, :scale => 0
    t.string   "isbn"
    t.string   "status"
    t.string   "po_number"
    t.string   "book_number"
    t.string   "cancel_reason"
    t.integer  "deferred_by",      :precision => 38, :scale => 0
    t.datetime "last_action_date"
    t.integer  "supplier_id",      :precision => 38, :scale => 0
    t.datetime "expiry_date"
    t.integer  "member_id",        :precision => 38, :scale => 0
    t.string   "card_id"
    t.integer  "branch_id",        :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",         :precision => 38, :scale => 0
  end

  create_table "publishers", :force => true do |t|
    t.string   "code"
    t.string   "imprintname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id",      :precision => 38, :scale => 0
    t.string   "publishername"
  end

  add_index "publishers", ["code"], :name => "index_publishers_on_code", :unique => true, :tablespace => "users"

  create_table "publishers_bkp", :id => false, :force => true do |t|
    t.integer  "id",            :precision => 38, :scale => 0, :null => false
    t.string   "code"
    t.string   "imprintname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id",      :precision => 38, :scale => 0
    t.string   "publishername"
  end

  create_table "publisherxrefs", :force => true do |t|
    t.integer  "isbnpublishercode", :precision => 38, :scale => 0
    t.integer  "publisher_id",      :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supplierdiscounts", :force => true do |t|
    t.integer  "publisher_id", :precision => 38, :scale => 0
    t.integer  "supplier_id",  :precision => 38, :scale => 0
    t.integer  "discount",     :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "bulkdiscount"
  end

  create_table "suppliers", :id => false, :force => true do |t|
    t.integer "id",                            :precision => 38, :scale => 0, :null => false
    t.string  "name",           :limit => 100
    t.string  "contact",        :limit => 100
    t.string  "phone",          :limit => 100
    t.string  "city",           :limit => 100
    t.integer "typeofshipping",                :precision => 38, :scale => 0
    t.integer "discount",                      :precision => 38, :scale => 0
    t.integer "creditperiod",                  :precision => 38, :scale => 0
  end

  create_table "suppliers_bkp", :id => false, :force => true do |t|
    t.integer "id",                            :precision => 38, :scale => 0, :null => false
    t.string  "name",           :limit => 100
    t.string  "contact",        :limit => 100
    t.string  "phone",          :limit => 100
    t.string  "city",           :limit => 100
    t.integer "typeofshipping",                :precision => 38, :scale => 0
    t.integer "discount",                      :precision => 38, :scale => 0
    t.integer "creditperiod",                  :precision => 38, :scale => 0
  end

  create_table "titlereceipts", :force => true do |t|
    t.string   "po_no"
    t.string   "invoice_no"
    t.string   "isbn"
    t.integer  "box_no",     :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workitems", :force => true do |t|
    t.integer  "worklist_id", :precision => 38, :scale => 0
    t.string   "item_type"
    t.integer  "ref_id",      :precision => 38, :scale => 0
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workitems_bkp", :id => false, :force => true do |t|
    t.integer  "id",          :precision => 38, :scale => 0, :null => false
    t.integer  "worklist_id", :precision => 38, :scale => 0
    t.string   "item_type"
    t.integer  "ref_id",      :precision => 38, :scale => 0
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "worklists", :force => true do |t|
    t.string   "description"
    t.string   "status"
    t.datetime "open_date"
    t.datetime "close_date"
    t.string   "created_by"
    t.string   "list_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "worklists_bkp", :id => false, :force => true do |t|
    t.integer  "id",          :precision => 38, :scale => 0, :null => false
    t.string   "description"
    t.string   "status"
    t.datetime "open_date"
    t.datetime "close_date"
    t.string   "created_by"
    t.string   "list_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_synonym "authentications", "authentications@link_opac", :force => true
  add_synonym "users", "users@link_opac", :force => true

end