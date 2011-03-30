class WorklistsController < ApplicationController
  respond_to :html, :js
  
  def index
    @worklists = Worklist.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    @worklist = Worklist.find(params[:id])
    if @worklist.description == "Procurement Items with No Supplier Data"
      render 'items_with_no_supplier_data'
    elsif @worklist.description == "Procurement Items with Details Not Verified"
      render 'items_with_details_not_enriched'
    elsif @worklist.description == "Procurement Items with PO not generated"
      render 'items_with_po_not_generated'
    end
  end
  
  def save_items_with_no_supplier_data
    data = params[:data]
    id = params[:id]
    items = Array.new
    
    result = true
    puts data.to_s
    data.each {|key, value|
      procurementitem = Procurementitem.find(value["id"])
      procurementitem.avl_quantity = value["quantity"] unless value["quantity"].nil?
      procurementitem.avl_status = value["avl_status"] unless value["avl_status"].nil?
      procurementitem.supplier_id = value["supplier_id"] unless value["supplier_id"].nil?
      
      if !procurementitem.save
        result = false
      end
    }
    
    if result == true
      flash[:success] = "Items have been Successfully Updated!"
    else
      flash[:error] = "Items updation failed!"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def save_items_with_details_not_enriched
    data = params[:data]
    id = params[:id]
    items = Array.new
    
    result = true
    data.each {|key, value|
      procurementitem = Procurementitem.find(value["id"])
      enrichedtitle = procurementitem.enrichedtitle
      enrichedtitle.verified = value["verified"] unless value["verified"].nil?
      
      if !enrichedtitle.save
        result = false
      end
    }
    
    if result == true
      flash[:success] = "Items have been Successfully Updated!"
    else
      flash[:error] = "Items updation failed!"
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def save_items_with_po_not_generated
    respond_to do |format|
      format.js
    end
  end
end
