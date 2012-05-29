class BookreceiptsController < ApplicationController
  def index
    unless params[:queryBookTagNo].blank?
      @bookreceipt = Bookreceipt.find_by_book_no(params[:queryBookTagNo])
      
      unless @bookreceipt.nil?          
        redirect_to @bookreceipt
      else
        render :not_found
      end
    end    
  end

  def show
    @bookreceipt = Bookreceipt.find(params[:id])
    @enrichedtitle = Enrichedtitle.find_by_isbn(@bookreceipt.isbn) 
    @procurementitem = Procurementitem.find_by_po_number_and_isbn(@bookreceipt.po_no, @bookreceipt.isbn)
    unless @procurementitem.nil?
      @matched_listitem = Listitem.find_by_procurementitem_id_and_book_no(@procurementitem.id, @bookreceipt.book_no)
      @open_listitems = Listitem.find_all_by_procurementitem_id_and_book_no(@procurementitem.id, nil)
    end
  end
  
  def fetch
    @bookreceipt = Bookreceipt.find_by_book_no(params[:book][:book_no])
    respond_to do |format|
      if @bookreceipt
        flash[:success] = "Fetched Successfully!"
        format.html { redirect_to bookreceipt_path}
        format.xml
      else
        flash[:error] = "Book not Found!"
        format.html { render :index }
        format.xml { render :nothing => true, :status => :not_found }
      end
    end
  end

  def new
    @bookreceipt = Bookreceipt.new
  end

  def create
    @bookreceipt = Bookreceipt.new(params[:bookreceipt])
    @bookreceipt.created_by = current_user.id
    
    respond_to do |format|      
      if @bookreceipt.save
        @daily_count = Bookreceipt.of_user_for_today(current_user.id).count
        flash[:success] = "Cataloged Successfully!"
        format.html { redirect_to bookreceipts_path}
        format.xml
      else
        if @bookreceipt.errors.count > 0 && @bookreceipt.errors.values.join("").include?("already been used")
          flash[:error] = "Cataloging failure!"
          format.html { render :new }
          format.xml { render :nothing => true, :status => :conflict }
        else
          flash[:error] = "Cataloging failure!"
          format.html { render :new }
          format.xml { render :nothing => true, :status => :precondition_failed }
        end
      end
    end
  end
  
  # DELETE /bookreceipts/1
  # DELETE /bookreceipts/1.xml
  def destroy
    @bookreceipt = Bookreceipt.find(params[:id])
    @bookreceipt.destroy
    @daily_count = Bookreceipt.of_user_for_today(current_user.id).count

    respond_to do |format|
      format.html { redirect_to(bookreceipts_url) }
      format.xml { render :daily_count_of_user }
    end
  end
  
  def daily_count_of_user
    @daily_count = Bookreceipt.of_user_for_today(current_user.id).count
    respond_to do |format|
      format.html { redirect_to(bookreceipts_url) }
      format.xml
    end
  end
end
