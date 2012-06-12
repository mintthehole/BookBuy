class TransferOrder < ActiveRecord::Base
  
  MATERIAL_TYPE_BOOK = 1001
  
  belongs_to :enrichedtitle
  
  FILE_COLUMNS = {
    :warehouse => 0,
    :to_date => 1,
    :to_number => 2,
    :to_item => 3,
    :movement_type => 4,
    :material_code => 5,
    :storage_location => 6,
    :material_type => 7,
    :storage_bin => 8,
    :required_quantity => 9
  }

  validate :is_material_valid, :on => :create
  validate :is_picked_quantity_valid

  validates_presence_of :warehouse, :to_date, :to_number, :to_item, :movement_type, :material_type, :material_code, :storage_location,
  :storage_bin, :required_quantity, :picked_quantity
  
  validates :to_number, :numericality => { :only_integer => true }
  validates :to_item, :numericality => { :only_integer => true }
  validates :movement_type, :numericality => { :only_integer => true }
  validates :material_type, :numericality => { :only_integer => true }
  validates :required_quantity, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :picked_quantity, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  attr_accessible :warehouse, :to_date, :to_number, :to_item, :movement_type, :material_type, :material_code, :storage_location,
  :storage_bin, :required_quantity, :picked_quantity
  
  def self.search(params)
    #transfer_orders = order('to_date desc').limit(10)
    transfer_orders = TransferOrder.where(:to_date => params[:to_date])
    transfer_orders = transfer_orders.where(:material_code => params[:material_code]) if params[:material_code].present?
    transfer_orders = transfer_orders.where(:storage_bin => params[:storage_bin]) if params[:storage_bin].present?
    transfer_orders.limit(10)
  end
  
  def self.create_file(transfer_orders)
    CSV.generate(:col_sep => "\t") do |line|
      line << %w[Warehouse TODate TONumber TOItem MovType MatNumber StorageLoc MaterialType StorageBin RequiredQuantity PickedQuantity]
      
      unless transfer_orders.nil?
        transfer_orders.each do |t|
        
          line << [
            t.warehouse,
            t.to_date,
            t.to_number,
            t.to_item,
            t.movement_type,
            t.material_code,
            t.storage_location,
            t.material_type,
            t.storage_bin,
            t.required_quantity,
            t.picked_quantity    
            ]
        end
      end
    end
  end

  private
   
  def is_material_valid
    return true unless material_type == MATERIAL_TYPE_BOOK

    isbn_or_title_id = material_code[1..-1]
    return true if Enrichedtitle.exists?(:isbn => isbn_or_title_id)       
    return true if Noisbntitle.exists?(:title_id => isbn_or_title_id)        

    errors.add(:material_code, ' not found in AMS')
   end
   
   def is_picked_quantity_valid
     return true if picked_quantity <= required_quantity
     
     errors.add(:picked_quantity, " cannot be greater than required quantity #{required_quantity}")
   end
  
end