class OutboundDelivery < ActiveRecord::Base
  
  FILE_COLUMNS = {
    :srl => 0,
    :material => 1,
    :serial => 2,
    :plant => 3,
    :plant_name => 4,
    :sto => 5,
    :delivery => 6,
    :date => 7,
    :bin => 8
  }
  
  has_many :outbound_delivery_items
  
  validates :delivery_no, :presence => true
  validates :sto_no, :presence => true
  validates :destination_plant, :presence => true

  validates_associated :outbound_delivery_items
  accepts_nested_attributes_for :outbound_delivery_items
  
  validate :is_destination_plant_valid
  
  attr_accessible :delivery_no, :sto_no, :destination_plant
  
  def branch_id
    destination_plant[1..-1].to_i
  end
  
  def self.build_from_params(params)
    obj = find_or_create_by_delivery_no_and_sto_no_and_destination_plant(params[:delivery_no],params[:sto_no], params[:destination_plant])
    unless obj.outbound_delivery_items.exists?(:book_no => params[:outbound_delivery_item][:book_no])
      obj.outbound_delivery_items.build(params[:outbound_delivery_item])
    end
    obj
  end
  
  private
  
  def is_destination_plant_valid
    errors.add(:destination_plant, ' is not a valid plant, should start with F') unless destination_plant[0] == 'F'    
    errors.add(:destination_plant, ' does not exist') unless Branch.exists?(destination_plant[1..-1])
  end
  
end
