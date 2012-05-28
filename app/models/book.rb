class Book < ActiveRecord::Base
  establish_connection "jbprod_#{RAILS_ENV}"
  
  set_primary_key :bookid
  set_sequence_name :seq_books
  
  set_integer_columns :times_rented
  
  belongs_to :title, :foreign_key => :titleid
  belongs_to :originallocation, :foreign_key => :origlocation, :class_name => 'Branch'
  belongs_to :currentlocation, :foreign_key => :location, :class_name => 'Branch'  
  
  validate :terms_of_update_must_be_accepted, :on => :update
  validate :isbn_or_title_id_must_be_in_core_list, :on => :update
  
  after_update :update_other_schemas
  
  attr_accessor :isbn_or_title_id, :terms_of_update
  attr_accessible :isbn_or_title_id, :terms_of_update, :isbn, :titleid, :booknumber, :mrp_cost, :jb_cost, :date_of_purchase,
  :insertdate, :status, :location, :origlocation, :userid, :times_rented, :book_number_str, :book_tag_number,
  :book_condition_rating

  searchable do
    text :titleid, :stored => true
    integer :times_rented, :stored => true
    integer :id, :stored => true
    text :decorated_book_no, :stored => true
    text :shelflocation, :stored => true
    integer :location, :references => Branch, :stored => true
    integer :origlocation, :references => Branch, :stored => true
    string :origlocation_type, :using => :origlocation_category, :stored => true
    boolean :available, :using => :available?, :stored => true
    integer :city_id, :stored => true
  end

  def title_type
    "B"
  end
    
  def decorated_book_no
    title_type + "0" + booknumber.to_s
  end
  
  def available?
    status == 'A' and origlocation == location and (location_valid || 'Y') != 'N'
  end
  
  def origlocation_category 
    return originallocation.category unless originallocation.nil?
    return nil
  end
  
  def city_id
    return originallocation.city_id unless originallocation.nil?
    return nil
  end
  
  def self.search(keyword, location, origlocation, available=nil, city_id=nil)
    search = Sunspot.new_search(Book) do
      paginate(:page => 1, :per_page => 500)
      facet(:location, :origlocation, :available, :city_id)
    end

    search.build do
      fulltext keyword
    end

    if origlocation
      search.build do
        with :origlocation, origlocation
      end
    end
    
    if location
      search.build do
        with :location, location
      end
    end
    
    if available
      search.build do
        with :available, available
      end
    end
    
    if city_id
      search.build do
        with :city_id, city_id
      end
    end
    
    search.build do
      with :origlocation_type, ['P', 'S']
    end
    
    search.execute
  end
  
  def copy_book_to_other_schemas
    copy_book_to_other_schema(BookMumbai.new)
    copy_book_to_other_schema(BookHyd.new)    
  end  
  
  private
  def copy_book_to_other_schema(b)
    self.attributes.each do |at|
      b[at[0]] = at[1]
    end
    b.id = self.id
    b.save!
  end
  
  def isbn_or_title_id_must_be_in_core_list
    errors.add(:titleid, ' is not present in Core List, create it first') unless title.in_core_list?
  end
  
  def terms_of_update_must_be_accepted
    t = Title.find(titleid)
    if t.try(:in_core_list?)
      errors.add(:terms_of_update, ' need to be accepted') unless terms_of_update == '1'
    end
  end  
  
  def update_other_schemas
    update_other_schema(BookMumbai.find(id))
    update_other_schema(BookHyd.find(id))
  end
  def update_other_schema(b)
    b.isbn = self.isbn
    b.titleid = self.titleid
    b.save!
  end
end