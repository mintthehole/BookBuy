class NoisbntitlesController < ApplicationController
  def index
    unless params[:queryTitleID].blank?
      @enrichedtitle = Enrichedtitle.find_by_title_id(params[:queryTitleID])
      if @enrichedtitle.nil?
        @noisbntitle = Noisbntitle.find_by_title_id(params[:queryTitleID])
        respond_to do |format|
          unless @noisbntitle.nil?
            format.html {render "show"}
            format.js {render :json => @noisbntitle}
          else
            format.html {redirect_to :action => 'new', :queryTitleID => params[:queryTitleID]}
            format.js {head :not_found}
          end
        end
      else
        respond_to do |format|
          format.html {render :enrichedtitle_found}
          format.js {head :forbidden}
        end
      end
    end
    
    unless params[:file_id].blank?
      send_data SAP::create_file(Noisbntitle, params[:file_id]),
          :type => 'text/text; charset=iso-8859-1; header=present',
          :disposition => "attachment; filename=#{params[:file_id]}.txt"
    end
  end
    
  def create
    @noisbntitle = Noisbntitle.new(params[:noisbntitle])

    if @noisbntitle.save
      redirect_to(@noisbntitle, :notice => 'Title was successfully created.')
    else
      render :action => "new"
    end
  end
  
  def new
    if Title.exists?(params[:queryTitleID])
      @noisbntitle = Noisbntitle.new_from_title(params[:queryTitleID])
    else
      render :not_found
    end
  end  
  
  def show
    @noisbntitle = Noisbntitle.find(params[:id])
  end
  
  def edit
    @noisbntitle = Noisbntitle.find(params[:id])
  end
  
  def update
    @noisbntitle = Noisbntitle.find(params[:id])

    if @noisbntitle.update_attributes(params[:noisbntitle])
      flash[:success] = 'Successfully updated.'
      redirect_to(@noisbntitle) 
    else
      render :action => "edit"
    end
  end  
end