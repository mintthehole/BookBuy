class EnrichedtitlesController < ApplicationController
  def index
    unless params[:queryISBN].blank?
      @enrichedtitle = Enrichedtitle.find_by_isbn(params[:queryISBN])
      respond_to do |format|
        unless @enrichedtitle.nil?
          format.html {render "show"}
          format.js {render :json => @enrichedtitle}
        else
          format.html {redirect_to :action => 'new', :isbn => params[:queryISBN]}
          format.js {head :not_found}
        end
      end
    end

    unless params[:file_id].blank?
      send_data SAP::create_file(Enrichedtitle, params),
          :type => 'text/text; charset=iso-8859-1; header=present',
          :disposition => "attachment; filename=#{params[:file_id]}.txt"
    end    
  end
  
  def edit
    @enrichedtitle = Enrichedtitle.find(params[:id])
  end
  
  def create
    @enrichedtitle = Enrichedtitle.new(params[:enrichedtitle])

    if @enrichedtitle.save
      redirect_to(@enrichedtitle, :notice => 'Title was successfully created.')
    else
      render :action => "new"
    end
  end
  
  def new
    @isbn = params[:isbn]
    @enrichedtitle = Enrichedtitle.new_from_web(@isbn)
  end
  
  def show
    @enrichedtitle = Enrichedtitle.find(params[:id])
  end
  
  def update
    @enrichedtitle = Enrichedtitle.find(params[:id])

    respond_to do |format|
      if @enrichedtitle.update_attributes(params[:enrichedtitle])
        format.html { redirect_to(@enrichedtitle, :notice => 'Enrichedtitle was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @enrichedtitle.errors, :status => :unprocessable_entity }
      end
    end
  end  
  
  def scan_web
    @enrichedtitle = Enrichedtitle.find(params[:id])
    @enrichedtitle.scan_web
    @enrichedtitle.web_scanned = 'ScanWeb'
    flash[:notice] = "Scanned Web"
    render :action => :edit
  end
  
  def upload
    if request.post? && params[:file].present?
      infile = params[:file].read
      n, errs = 0, []
      
      @rows = CSV.parse(infile)
    end
  end
  
  def update_with_isbn
    @form_id = params[:et_id]
    @et = Enrichedtitle.find_by_isbn(params[:et][:isbn])
    @et.update_attributes(params[:et]) unless @et.nil?
    respond_to do |format|
      format.js {render :layout => false}
    end      
  end  
end
