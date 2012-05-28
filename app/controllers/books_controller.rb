class BooksController < ApplicationController
  def index
    unless params[:queryBookTagNo].blank?
      @book = Book.find_by_booknumber(params[:queryBookTagNo][1..-1])
      respond_to do |format|
        unless @book.nil?
          format.html {render :show}
          format.js {render :json => @book}
        else
          format.html {render :not_found}
          format.js {head :not_found}
        end
      end
    end    
  end
  
  def edit
    @book = Book.find(params[:id])    
  end
  
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:book])
        format.html { redirect_to(@book, :notice => 'Book was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
    
  end
  
  def show
    @book = Book.find(params[:id])
  end
  
end