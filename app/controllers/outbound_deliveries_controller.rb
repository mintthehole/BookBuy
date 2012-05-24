require 'csv'
class OutboundDeliveriesController < ApplicationController
  respond_to :html, :js
  
  def index
    @outbound_deliveries = OutboundDelivery.order(:created_at).paginate(:per_page => 50, :page => params[:page])
  end
  
  def upload
    if request.post? && params[:file].present?
      infile = params[:file].read
      n, errs = 0, []
      
      @rows = CSV.parse(infile)
      @rows.shift
    end
  end
  
  def create
    @form_id = params[:outbound_delivery_id]
    outbound_delivery = OutboundDelivery.find_or_create_by_delivery_no_and_sto_no_and_destination_plant(params[:delivery_no],params[:sto_no], params[:destination_plant])
    @errors = outbound_delivery.errors unless outbound_delivery.valid?
    
    if outbound_delivery.valid?
      material_code = params[:material_code]
      book_no = params[:book_no]
      outbound_delivery_id = outbound_delivery.id
      outbound_delivery_item = OutboundDeliveryItem.find_or_create_by_book_no(:book_no => book_no, :material_code => material_code, :outbound_delivery_id => outbound_delivery_id)
      @errors = outbound_delivery_items.errors unless outbound_delivery_item.valid?
    end

    respond_with( @errors, :layout => !request.xhr? )    
  end
end