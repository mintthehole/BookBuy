class Noisbntitle < ActiveRecord::Base
  acts_as_versioned
  
  belongs_to :publisher
  belongs_to :category
  belongs_to :jbtitle, :foreign_key => "title_id", :class_name => "Title"
  belongs_to :jbcategory, :foreign_key => 'category_id', :class_name => "Category"
  
  
  has_attached_file :cover, :styles => {:thumb => "100x100>", :medium => "200x200>"}, 
  :path => ':style/:id.:extension', :default_url => "/images/missing_:style.jpg"
  
  validates :title, :presence => true
  validates :author, :presence => true
  validates :language, :presence => true
  validates :currency, :presence => true
  validates :listprice, :presence => true, :numericality => true
  validates :category_id, :presence => true, :numericality => true
  validates :publisher_name, :presence => true
  validates :publisher_id, :presence => true, :numericality => true
  validates :pub_year, :presence => true, :numericality => true
  validates :format, :presence => true
  validates :page_cnt, :presence => true, :numericality => true
  validates :t_title, :presence => true
  validates :t_author, :presence => true
  
  validates_attachment_size :cover, :less_than => 50.kilobytes, :message => 'file size maximum 50 KB allowed'
  validates_attachment_content_type :cover, :content_type => ['image/jpeg']
  
  before_create :upsert_legacy_title
  
  before_validation :set_defaults_on_create

  def self.new_from_title(legacytitleid)
    nt = new
    legacytitle = Title.find(legacytitleid)
  
    return if legacytitle.nil?
  
    nt.jbtitle = legacytitle
    nt.title = legacytitle.title
    nt.author = legacytitle.author.name unless legacytitle.author.nil?

    nt
  end
  
  private
  def set_defaults_on_create
    self.verified = 'N'
    self.enriched = 'N'
    self.publisher_name = self.publisher.name unless self.publisher.nil?
  end
  
  def upsert_legacy_title
    attributes = {
      :title => self.title,
      :authorid => Author.find_or_create_by_firstname(self.author).id,
      :publisherid => (self.publisher.id unless self.publisher.nil?),
      :isbn_10 => 'NOISBN',
      :isbn_13 => 'NOISBN',
      :category => self.jbcategory,
      :language => self.language,
      :titletype => 'B',
      :insertdate => Time.zone.now,
      :userid => 'AMS',
      :flag_isbn_image => ('Y' unless cover.nil?),
      :mrp => self.listprice,
      :yearofpublication => self.pub_year,
      :no_of_pages => self.page_cnt,
      :format => self.format
    }
    if self.jbtitle.nil?
      self.jbtitle = Title.create!(attributes)
    else
      self.jbtitle.update_attributes!(attributes)
    end    
  end  
end
