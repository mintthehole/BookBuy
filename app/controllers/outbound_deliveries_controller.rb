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
    end
  end
  
  def create
    @form_id = params[:outbound_delivery_id]
    @outbound_delivery = OutboundDelivery.build_from_params( params[:outbound_delivery] )
    flash[:notice] = "Outbound Delivery successfully created" if @outbound_delivery.save
    respond_with( @outbound_delivery, :layout => !request.xhr? )    
  end
end