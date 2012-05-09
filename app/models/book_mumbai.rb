class BookMumbai < ActiveRecord::Base
  establish_connection "jbmumbai_#{RAILS_ENV}"
  set_table_name :books
  set_primary_key :bookid
end
