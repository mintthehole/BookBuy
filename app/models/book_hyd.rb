class BookHyd < ActiveRecord::Base
  establish_connection "jbhyd_#{RAILS_ENV}"
  set_table_name :books
  set_primary_key :bookid
end
