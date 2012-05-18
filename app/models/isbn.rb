class Isbn
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :isbn_str

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end

  def decorated_13digit
    Isbnutil::Isbn.parse(isbn_str, nil, true).asIsbn13
  end
  
  def undecorated_13digit
    Isbnutil::Isbn.parse(isbn_str, nil, true).asIsbn13.gsub(/-/,'')
  end

  def decorated_10digit
    Isbnutil::Isbn.parse(isbn_str, nil, true).asIsbn10
  end
  
  def undecorated_10digit
    Isbnutil::Isbn.parse(isbn_str, nil, true).asIsbn10.gsub(/-/,'')
  end
  
  def valid?
    i = Isbnutil::Isbn.parse(isbn_str, nil, true)
    return false if i.nil?
    i.isValid
  end
end