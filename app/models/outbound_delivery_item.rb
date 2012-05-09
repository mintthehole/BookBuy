class OutboundDeliveryItem < ActiveRecord::Base
  belongs_to :outbound_delivery
  
  validates :material_code, :presence => true
  validates :book_no, :presence => true
  validates_uniqueness_of :book_no
  
  validate :is_material_code_valid
  validate :is_book_no_valid
  
  attr_accessible :material_code, :book_no, :outbound_delivery_id
  attr_accessor :title_id, :isbn, :inr_price
  
  before_create :create_book_in_catalog
  
  private
  
  def is_material_code_valid
    errors.add(:material, ' is not of valid format, should start with F') unless material_code[0] == 'F'
    
    isbn_or_title_id = material_code[1..-1]
    if Enrichedtitle.exists?(:isbn => isbn_or_title_id)
      et = Enrichedtitle.find_by_isbn(isbn_or_title_id)
      self.isbn = isbn_or_title_id
      self.title_id = et.title_id
      self.inr_price = et.inr_price
    else
      if Noisbntitle.exists?(:title_id => isbn_or_title_id)        
        nt = Noisbntitle.find_by_title_id(isbn_or_title_id)        
        self.isbn = 'NOISBN'
        self.title_id = isbn_or_title_id        
        self.inr_price = nt.inr_price
      else
        errors.add(:material, ' not found in AMS')
      end
    end    
  end
  
  def is_book_no_valid
    errors.add(:book_no, ' should start with B') unless book_no[0] == 'B'
    errors.add(:book_no, ' should be of a format B followed by integers') if book_no[1..-1].to_i == 0
    errors.add(:book_no, ' is already cataloged') if Book.exists?(:book_tag_number => book_no)
  end
  
  def create_book_in_catalog
    attributes = {
      :isbn => self.isbn,
      :titleid => self.title_id,
      :booknumber => self.book_no[1..-1],
      :mrp_cost => self.inr_price,
      :jb_cost => self.inr_price,
      :date_of_purchase => Time.zone.now,
      :insertdate => Time.zone.today,
      :status => 'P',
      :location => self.outbound_delivery.branch_id,
      :origlocation => self.outbound_delivery.branch_id,
      :userid => 'SAP',
      :times_rented => 0,
      :book_number_str => self.book_no[1..-1].to_i,
      :book_tag_number => self.book_no
    }
    book = Book.create!(attributes)
    book.copy_book_to_other_schemas
  end
end
