require 'csv'
class TransferOrdersController < ApplicationController
  respond_to :html, :xml, :js, :csv

  def index
    @transfer_orders = TransferOrder.search(params)

    respond_with (@transfer_orders) do |format|
      format.csv {
        send_data TransferOrder::create_file(@transfer_orders),
            :type => 'text/text; charset=iso-8859-1; header=present',
            :disposition => "attachment; filename=tos.txt"
      }
    end
    
  end
  
  def search
    @transfer_order = TransferOrder.find_by_to_date_and_material_code_and_storage_location(params[:to_date], params[:material_code], params[:storage_location])
    
    respond_with(@transfer_order) do |format|
      format.html { redirect_to @transfer_order unless @transfer_order.nil? }
    end
  end
  
  def show
    @transfer_order = TransferOrder.find(params[:id])
    
    respond_with(@transfer_order)
  end
  
  def edit
    @transfer_order = TransferOrder.find(params[:id])
    
    respond_with(@transfer_order)
  end
  
  def update
    @transfer_order = TransferOrder.find(params[:id])

    if @transfer_order.update_attributes(params[:transfer_order])
      flash[:notice] = 'Successfully updated.'
    end
      
    respond_with(@transfer_order)    
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
    @form_id = params[:id]
    unless TransferOrder.scoped_by_to_number_and_to_item(params[:transfer_order][:to_number], params[:transfer_order][:to_item]).exists? 
      transfer_order = TransferOrder.create(params[:transfer_order])
      @errors = transfer_order.errors unless transfer_order.valid?
    end

    respond_with( @errors, :layout => !request.xhr? )    
  end

end